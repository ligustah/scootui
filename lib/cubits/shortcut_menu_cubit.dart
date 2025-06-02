import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/mdb_repository.dart';
import '../state/vehicle.dart';
import 'debug_overlay_cubit.dart';
import 'mdb_cubits.dart';
import 'screen_cubit.dart';
import 'theme_cubit.dart';
// import 'trip_cubit.dart'; // Commented out since resetTrip is removed

enum ShortcutMenuState {
  hidden,
  visible,
  confirmingSelection,
}

enum ShortcutMenuItem {
  toggleHazards,
  toggleView,
  toggleTheme,
  toggleDebugOverlay,
  // resetTrip, // Commented out for now
}

// Centralized menu items structure with metadata
class MenuItemData {
  final ShortcutMenuItem item;
  final String label;
  final IconData icon;
  final String description;

  const MenuItemData({
    required this.item,
    required this.label,
    required this.icon,
    required this.description,
  });
}

class MenuItems {
  static const List<MenuItemData> items = [
    MenuItemData(
      item: ShortcutMenuItem.toggleHazards,
      label: 'Hazards',
      icon: Icons.warning_amber_rounded,
      description: 'Toggle hazard lights',
    ),
    MenuItemData(
      item: ShortcutMenuItem.toggleView,
      label: 'View',
      icon: Icons.remove_red_eye_outlined,
      description: 'Switch between cluster and map view',
    ),
    MenuItemData(
      item: ShortcutMenuItem.toggleTheme,
      label: 'Theme',
      icon: Icons.brightness_6,
      description: 'Cycle theme: dark → light → auto',
    ),
    MenuItemData(
      item: ShortcutMenuItem.toggleDebugOverlay,
      label: 'Debug',
      icon: Icons.bug_report,
      description: 'Toggle debug overlay',
    ),
  ];

  static MenuItemData getItemData(ShortcutMenuItem item) {
    return items.firstWhere((data) => data.item == item);
  }

  static IconData getViewToggleIcon(bool isClusterView) {
    return isClusterView ? Icons.map_outlined : Icons.speed;
  }

  static IconData getThemeToggleIcon(bool isAutoMode, ThemeMode currentTheme) {
    if (isAutoMode) {
      // auto → dark (next state is dark)
      return Icons.dark_mode;
    } else if (currentTheme == ThemeMode.dark) {
      // dark → light (next state is light)
      return Icons.light_mode;
    } else {
      // light → auto (next state is auto)
      return Icons.contrast;
    }
  }
}

class ShortcutMenuCubit extends Cubit<ShortcutMenuState> {
  final VehicleSync _vehicleSync;
  final ScreenCubit _screenCubit;
  final ThemeCubit _themeCubit;
  final DebugOverlayCubit _debugOverlayCubit;
  // final TripCubit _tripCubit; // Commented out since resetTrip is removed
  final MDBRepository _mdbRepository;

  late final StreamSubscription<VehicleData> _vehicleSubscription;
  StreamSubscription<(String, String)>? _buttonEventsSubscription;

  // Button press tracking
  DateTime? _buttonPressStartTime;
  DateTime? _lastTapTime; // Changed from _buttonReleaseTime to track tap-to-tap
  Timer? _longPressTimer;
  Timer? _selectionTimer;
  Timer? _cycleTimer;

  // Menu state - using ValueNotifier for more reliable updates
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);
  bool _isConfirming = false;

  // Constants
  static const Duration _doublePressDuration = Duration(milliseconds: 500);
  static const Duration _longPressDuration = Duration(milliseconds: 500);
  static const Duration _itemCycleDuration = Duration(milliseconds: 750);
  static const Duration _confirmDuration = Duration(seconds: 1);

  // List of menu items from centralized structure
  final List<ShortcutMenuItem> _menuItems = MenuItems.items.map((data) => data.item).toList();

  ShortcutMenuCubit({
    required VehicleSync vehicleSync,
    required ScreenCubit screenCubit,
    required ThemeCubit themeCubit,
    required DebugOverlayCubit debugOverlayCubit,
    // required TripCubit tripCubit, // Commented out since resetTrip is removed
    required MDBRepository mdbRepository,
  })  : _vehicleSync = vehicleSync,
        _screenCubit = screenCubit,
        _themeCubit = themeCubit,
        _debugOverlayCubit = debugOverlayCubit,
        // _tripCubit = tripCubit, // Commented out since resetTrip is removed
        _mdbRepository = mdbRepository,
        super(ShortcutMenuState.hidden) {
    // Listen for vehicle state changes via hash polling
    _vehicleSubscription = _vehicleSync.stream.listen(_handleVehicleStateChange);

    // Subscribe to direct button events channel for more responsive UI
    _buttonEventsSubscription = _mdbRepository.subscribe("buttons").listen(_handleButtonEvent);
  }

  void _handleButtonEvent((String channel, String message) event) {
    final buttonEvent = event.$2;
    _log('Received button event: $buttonEvent');

    // Parse the button event
    final parts = buttonEvent.split(':');
    if (parts.length < 2) return;

    final button = parts[0];
    final state = parts[1];

    // Only handle seatbox button for menu operations
    if (button == 'seatbox') {
      // Skip if not in ready-to-drive state
      if (_vehicleSync.state.state != ScooterState.readyToDrive) {
        return;
      }

      if (state == 'on') {
        _log('Seatbox button pressed via PUBSUB');
        _handleButtonPress();
      } else if (state == 'off') {
        _log('Seatbox button released via PUBSUB');
        _handleButtonRelease();
      }
    }
  }

  void _handleVehicleStateChange(VehicleData vehicleData) {
    // If we're no longer in drive mode, hide the menu
    if (vehicleData.state != ScooterState.readyToDrive && state != ShortcutMenuState.hidden) {
      _log('No longer in ready-to-drive state, hiding menu');
      emit(ShortcutMenuState.hidden);
    }
  }

  // Helper method to log with both developer.log and print
  void _log(String message) {
    print('SHORTCUT_MENU: $message');
  }

  void _handleButtonPress() {
    final now = DateTime.now();
    _log('Seatbox button pressed');
    _log('Current menu state: $state');

    // If we're in confirming state, this is a confirmation press
    if (state == ShortcutMenuState.confirmingSelection) {
      _log('Confirmation press detected - triggering selected action');
      _executeSelectedAction();
      _resetState();
      return;
    }

    // Check for double tap (toggle hazards) - but only if we're not already in a press sequence
    // We need to be careful here - only check for double tap if we're not currently tracking a press
    if (_buttonPressStartTime == null && _lastTapTime != null && now.difference(_lastTapTime!) < _doublePressDuration) {
      _log('Double tap detected - toggling hazards');
      _executeAction(ShortcutMenuItem.toggleHazards);
      _resetState();
      return;
    }

    // If we're already tracking a press, ignore this event
    // This prevents multiple button press events from resetting our timer
    if (_buttonPressStartTime != null) {
      _log('Already tracking a button press - ignoring duplicate event');
      return;
    }

    // Start tracking this press
    _buttonPressStartTime = now;
    _log('Starting button press tracking, waiting for long press (${_longPressDuration.inMilliseconds}ms)');

    // Start long press timer
    _longPressTimer?.cancel();
    _longPressTimer = Timer(_longPressDuration, () {
      // Long press detected, show menu
      _log('Long press detected (${_longPressDuration.inMilliseconds}ms) - showing menu');

      // Reset selected index to 0
      selectedIndexNotifier.value = 0;
      _log('Initial focus: ${_menuItems[selectedIndexNotifier.value]} (index: ${selectedIndexNotifier.value})');

      // Show menu
      emit(ShortcutMenuState.visible);
      _log('Menu state changed to VISIBLE');

      // Start cycling through menu items
      _startCyclingItems();
    });
  }

  void _handleButtonRelease() {
    // If we're not tracking a press, ignore this event
    if (_buttonPressStartTime == null) {
      _log('Button release detected but no press was being tracked - ignoring');
      return;
    }

    // Cancel the long press timer (if it's still active)
    _longPressTimer?.cancel();

    final now = DateTime.now();
    _log('Seatbox button released');
    _log('Current menu state: $state');

    // Calculate hold duration
    final holdDuration = now.difference(_buttonPressStartTime!);
    _log('Button was held for ${holdDuration.inMilliseconds}ms');

    // If menu is visible, handle selection
    if (state == ShortcutMenuState.visible) {
      // Now we can cancel the cycling timer since we're moving to confirmation state
      _cycleTimer?.cancel();

      _isConfirming = true;
      int currentIndex = selectedIndexNotifier.value;
      _log('Menu item selected: ${_menuItems[currentIndex]} (index: $currentIndex)');

      emit(ShortcutMenuState.confirmingSelection);
      _log('Menu state changed to CONFIRMING_SELECTION');
      _log('Waiting for confirmation press (timeout: ${_confirmDuration.inMilliseconds}ms)');

      // Start confirmation timer
      _selectionTimer?.cancel();
      _selectionTimer = Timer(_confirmDuration, () {
        // Timeout, hide menu
        _log('Confirmation timeout - hiding menu');
        _resetState();
      });
    }

    // If it was a short press, keep tracking for potential double press
    else if (holdDuration < _longPressDuration) {
      _log(
          'Short press detected - waiting for potential double press (window: ${_doublePressDuration.inMilliseconds}ms)');
      // Record this tap time for potential double tap detection (tap-to-tap timing)
      _lastTapTime = _buttonPressStartTime; // Use the original press time, not release time
    }

    _buttonPressStartTime = null;
  }

  void _startCyclingItems() {
    _cycleTimer?.cancel();
    _log('Starting menu item cycling (interval: ${_itemCycleDuration.inMilliseconds}ms)');

    // Start with the first item
    selectedIndexNotifier.value = 0;
    _log('Initial focus: ${_menuItems[0]} (index: 0)');

    // Create a periodic timer that updates the selected index
    _cycleTimer = Timer.periodic(_itemCycleDuration, (timer) {
      // Cycle to next item
      final previousIndex = selectedIndexNotifier.value;
      final nextIndex = (previousIndex + 1) % _menuItems.length;

      // Update the notifier value to trigger UI updates
      selectedIndexNotifier.value = nextIndex;

      _log(
          'Focus changed: ${_menuItems[previousIndex]} → ${_menuItems[nextIndex]} (index: $previousIndex → $nextIndex)');
    });
  }

  void _executeSelectedAction() {
    final currentIndex = selectedIndexNotifier.value;
    if (currentIndex >= 0 && currentIndex < _menuItems.length) {
      _executeAction(_menuItems[currentIndex]);
    }
  }

  void _executeAction(ShortcutMenuItem item) {
    _log('SHORTCUT TRIGGERED: $item');
    switch (item) {
      case ShortcutMenuItem.toggleHazards:
        _vehicleSync.toggleHazardLights();
        _log('Hazard lights toggled');
        break;
      case ShortcutMenuItem.toggleView:
        final currentState = _screenCubit.state;
        if (currentState is ScreenCluster) {
          _screenCubit.showMap();
          _log('Switched to map view');
        } else {
          _screenCubit.showCluster();
          _log('Switched to cluster view');
        }
        break;
      case ShortcutMenuItem.toggleTheme:
        _cycleTheme();
        _log('Theme cycled');
        break;
      case ShortcutMenuItem.toggleDebugOverlay:
        _debugOverlayCubit.toggleMode();
        _log('Debug overlay toggled');
        break;
    }
  }

  void _cycleTheme() {
    final currentState = _themeCubit.state;
    if (currentState.isAutoMode) {
      // auto → dark
      _themeCubit.updateAutoTheme(false);
      _themeCubit.updateTheme(ThemeMode.dark);
    } else if (currentState.themeMode == ThemeMode.dark) {
      // dark → light
      _themeCubit.updateTheme(ThemeMode.light);
    } else {
      // light → auto
      _themeCubit.updateAutoTheme(true);
    }
  }

  void _resetState() {
    _longPressTimer?.cancel();
    _selectionTimer?.cancel();
    _cycleTimer?.cancel();

    final previousState = state;
    final previousIndex = selectedIndexNotifier.value;

    selectedIndexNotifier.value = 0;
    _isConfirming = false;
    emit(ShortcutMenuState.hidden);

    _log('Menu reset: state $previousState → HIDDEN, index $previousIndex → 0');
  }

  // Getters for UI
  int get selectedIndex => selectedIndexNotifier.value;
  List<ShortcutMenuItem> get menuItems => _menuItems;
  bool get isConfirming => _isConfirming;

  // For testing/debugging
  void manualToggleHazards() {
    _executeAction(ShortcutMenuItem.toggleHazards);
  }

  void manualToggleTheme() {
    _executeAction(ShortcutMenuItem.toggleTheme);
  }

  void manualToggleDebugOverlay() {
    _executeAction(ShortcutMenuItem.toggleDebugOverlay);
  }

  // void manualResetTrip() {
  //   _executeAction(ShortcutMenuItem.resetTrip);
  // }

  static ShortcutMenuCubit create(BuildContext context) {
    return ShortcutMenuCubit(
      vehicleSync: context.read<VehicleSync>(),
      screenCubit: context.read<ScreenCubit>(),
      themeCubit: context.read<ThemeCubit>(),
      debugOverlayCubit: context.read<DebugOverlayCubit>(),
      // tripCubit: context.read<TripCubit>(), // Commented out since resetTrip is removed
      mdbRepository: RepositoryProvider.of<MDBRepository>(context),
    );
  }

  @override
  Future<void> close() {
    _vehicleSubscription.cancel();
    _buttonEventsSubscription?.cancel();
    _longPressTimer?.cancel();
    _selectionTimer?.cancel();
    _cycleTimer?.cancel();
    selectedIndexNotifier.dispose();
    return super.close();
  }
}

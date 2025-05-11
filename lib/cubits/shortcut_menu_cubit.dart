import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redis/redis.dart';

import '../repositories/mdb_repository.dart';
import '../services/redis_connection_manager.dart';
import '../state/enums.dart';
import '../state/vehicle.dart';
import 'debug_overlay_cubit.dart';
import 'mdb_cubits.dart';
import 'theme_cubit.dart';
import 'trip_cubit.dart';

enum ShortcutMenuState {
  hidden,
  visible,
  confirmingSelection,
}

enum ShortcutMenuItem {
  toggleHazards,
  toggleTheme,
  toggleDebugOverlay,
  resetTrip,
}

class ShortcutMenuCubit extends Cubit<ShortcutMenuState> {
  final VehicleSync _vehicleSync;
  final ThemeCubit _themeCubit;
  final DebugOverlayCubit _debugOverlayCubit;
  final TripCubit _tripCubit;
  final MDBRepository _mdbRepository;

  late final StreamSubscription<VehicleData> _vehicleSubscription;
  StreamSubscription<(String, String)>? _buttonEventsSubscription;

  // Button press tracking
  DateTime? _buttonPressStartTime;
  DateTime? _buttonReleaseTime;
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

  // List of menu items
  final List<ShortcutMenuItem> _menuItems = [
    ShortcutMenuItem.toggleHazards,
    ShortcutMenuItem.toggleTheme,
    ShortcutMenuItem.toggleDebugOverlay,
    ShortcutMenuItem.resetTrip,
  ];

  ShortcutMenuCubit({
    required VehicleSync vehicleSync,
    required ThemeCubit themeCubit,
    required DebugOverlayCubit debugOverlayCubit,
    required TripCubit tripCubit,
    required MDBRepository mdbRepository,
  })  : _vehicleSync = vehicleSync,
        _themeCubit = themeCubit,
        _debugOverlayCubit = debugOverlayCubit,
        _tripCubit = tripCubit,
        _mdbRepository = mdbRepository,
        super(ShortcutMenuState.hidden) {
    // Listen for vehicle state changes via hash polling
    _vehicleSubscription =
        _vehicleSync.stream.listen(_handleVehicleStateChange);

    // Subscribe to direct button events channel for more responsive UI
    _buttonEventsSubscription =
        _mdbRepository.subscribe("buttons").listen(_handleButtonEvent);
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

    // We now rely on PUBSUB events for button handling, no need to check button state here
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

    // Check for double press (toggle hazards)
    if (_buttonReleaseTime != null &&
        now.difference(_buttonReleaseTime!) < _doublePressDuration) {
      _log('Double press detected - toggling hazards');
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
    _log(
        'Starting button press tracking, waiting for long press (${_longPressDuration.inMilliseconds}ms)');

    // Start long press timer
    _longPressTimer?.cancel();
    _longPressTimer = Timer(_longPressDuration, () {
      // Long press detected, show menu
      _log(
          'Long press detected (${_longPressDuration.inMilliseconds}ms) - showing menu');

      // Reset selected index to 0
      selectedIndexNotifier.value = 0;
      _log(
          'Initial focus: ${_menuItems[selectedIndexNotifier.value]} (index: ${selectedIndexNotifier.value})');

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
    _buttonReleaseTime = now;
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
      _log(
          'Menu item selected: ${_menuItems[currentIndex]} (index: $currentIndex)');

      emit(ShortcutMenuState.confirmingSelection);
      _log('Menu state changed to CONFIRMING_SELECTION');
      _log(
          'Waiting for confirmation press (timeout: ${_confirmDuration.inMilliseconds}ms)');

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
    }

    _buttonPressStartTime = null;
  }

  void _startCyclingItems() {
    _cycleTimer?.cancel();
    _log(
        'Starting menu item cycling (interval: ${_itemCycleDuration.inMilliseconds}ms)');

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
      case ShortcutMenuItem.toggleTheme:
        _themeCubit.toggleTheme();
        _log('Theme toggled');
        break;
      case ShortcutMenuItem.toggleDebugOverlay:
        _debugOverlayCubit.toggleMode();
        _log('Debug overlay toggled');
        break;
      case ShortcutMenuItem.resetTrip:
        _tripCubit.reset();
        _log('Trip counter reset');
        break;
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

  void manualResetTrip() {
    _executeAction(ShortcutMenuItem.resetTrip);
  }

  static ShortcutMenuCubit create(BuildContext context) {
    return ShortcutMenuCubit(
      vehicleSync: context.read<VehicleSync>(),
      themeCubit: context.read<ThemeCubit>(),
      debugOverlayCubit: context.read<DebugOverlayCubit>(),
      tripCubit: context.read<TripCubit>(),
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

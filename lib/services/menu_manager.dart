import 'package:flutter/material.dart';
import '../models/vehicle_state.dart';
import '../widgets/menu/menu_item.dart';
import 'redis_service.dart';
import 'map_service.dart';

class MenuManager extends ChangeNotifier {
  bool _isMenuVisible = false;
  bool _isInSubmenu = false;
  int _selectedIndex = 0;
  List<MenuItem> _menuItems = [];
  DateTime? _lastLeftBrakePress;
  static const _doublePressThreshold = Duration(milliseconds: 300);
  ThemeMode _currentTheme = ThemeMode.dark;
  final Function(ThemeMode) _onThemeChanged;
  final VehicleState _vehicleState;
  late RedisService _redisService;
  Function(bool)? onMapViewToggled;
  bool _isMapView = false;
  bool _isMapAvailable = false;

  final Function() _onResetTrip;
  
  MenuManager(this._onThemeChanged, this._vehicleState, this._redisService, this._onResetTrip) {
    _initializeMenu();
  }

  Future<void> _initializeMenu() async {
    _isMapAvailable = await MapService.isMapAvailable();
    _buildMenuItems();
    notifyListeners();
  }

  void _buildMenuItems() {
    final List<MenuItem> items = [];
    
    if (_isMapAvailable) {
      items.add(
        MenuItem(
          title: 'Show Map View',
          type: MenuItemType.action,
          onChanged: (_) {
            _isMapView = !_isMapView;
            onMapViewToggled?.call(_isMapView);
            _updateMapViewMenuItem();
            closeMenu();
          },
        ),
      );
    }

    items.addAll([
      MenuItem(
        title: 'Hazard lights',
        type: MenuItemType.action,
        onChanged: (_) {
          _toggleHazardLights();
          closeMenu();
        },
      ),
      MenuItem(
        title: 'Change Theme',
        type: MenuItemType.action,
        onChanged: (_) {
          final newTheme = _currentTheme == ThemeMode.dark 
              ? ThemeMode.light 
              : ThemeMode.dark;
          _currentTheme = newTheme;
          _onThemeChanged(newTheme);
          notifyListeners();
        },
      ),
      MenuItem(
        title: 'Reset Trip',
        type: MenuItemType.action,
        onChanged: (_) {
          _onResetTrip();
          closeMenu();
        },
      ),
      MenuItem(
        title: 'Exit Menu',
        type: MenuItemType.action,
        onChanged: (_) => closeMenu(),
      ),
    ]);

    _menuItems = items;
  }

  void _updateMapViewMenuItem() {
    if (!_isMapAvailable) return;
    
    _menuItems[0] = MenuItem(
      title: _isMapView ? 'Show Dashboard' : 'Show Map View',
      type: MenuItemType.action,
      onChanged: (_) {
        _isMapView = !_isMapView;
        onMapViewToggled?.call(_isMapView);
        _updateMapViewMenuItem();
        closeMenu();
      },
    );
    notifyListeners();
  }

  bool get isMenuVisible => _isMenuVisible;
  bool get isInSubmenu => _isInSubmenu;
  int get selectedIndex => _selectedIndex;
  List<MenuItem> get menuItems => _menuItems;
  ThemeMode get currentTheme => _currentTheme;

  void handleLeftBrake(bool isParked, String state) {
    final now = DateTime.now();

    // Only handle brake press events ('on'), not releases ('off')
    if (state != 'on') return;

    if (isParked && !_isMenuVisible) {
      if (_lastLeftBrakePress != null &&
          now.difference(_lastLeftBrakePress!) <= _doublePressThreshold &&
          now.difference(_lastLeftBrakePress!) > Duration(milliseconds: 50)) {
        _selectedIndex = 0;
        _isMenuVisible = true;
        _lastLeftBrakePress = null;
        notifyListeners();
      } else {
        _lastLeftBrakePress = now;
      }
      return;
    }

    if (_isMenuVisible) {
      if (_isInSubmenu) {
        _handleSubmenuNavigation();
      } else {
        _selectedIndex = (_selectedIndex + 1) % _menuItems.length;
        notifyListeners();
      }
    }
  }

  void handleRightBrake() {
    if (!_isMenuVisible) return;

    final currentItem = _menuItems[_selectedIndex];
    
    if (currentItem.type == MenuItemType.action) {
      currentItem.onChanged?.call(null);
      return;
    }

    if (_isInSubmenu) {
      if (currentItem.type == MenuItemType.toggle) {
        final newValue = (currentItem.currentValue! + 1) % currentItem.options!.length;
        currentItem.onChanged?.call(newValue);
      }
      _isInSubmenu = false;
    } else {
      if (currentItem.type != MenuItemType.action) {
        _isInSubmenu = true;
      }
      notifyListeners();
    }
  }

  void _handleSubmenuNavigation() {
    // Removed submenu handling
  }

  void closeMenu() {
    _isMenuVisible = false;
    _isInSubmenu = false;
    //_selectedIndex = 0;
    notifyListeners();
  }

  void updateThemeMode(ThemeMode mode) {
    _currentTheme = mode;
    notifyListeners();
  }

  void _toggleHazardLights() async {
    await _redisService.toggleHazardLights();
  }
}
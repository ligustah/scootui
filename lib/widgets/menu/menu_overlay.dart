import 'package:flutter/material.dart';
import '../../models/vehicle_state.dart';
import 'menu_item.dart';

class MenuOverlay extends StatefulWidget {
  final VehicleState vehicleState;
  final Function(ThemeMode) onThemeChanged;
  final VoidCallback onClose;
  final bool isVisible;
  final List<MenuItem> menuItems;
  final int selectedIndex;
  final bool isInSubmenu;

  const MenuOverlay({
    super.key,
    required this.vehicleState,
    required this.onThemeChanged,
    required this.onClose,
    required this.isVisible,
    required this.menuItems,
    required this.selectedIndex,
    required this.isInSubmenu,
  });

  @override
  State<MenuOverlay> createState() => _MenuOverlayState();
}

class _MenuOverlayState extends State<MenuOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;
  late ScrollController _scrollController;
  bool _showTopScrollIndicator = false;
  bool _showBottomScrollIndicator = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _scrollController = ScrollController()
      ..addListener(_updateScrollIndicators);
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollIndicators() {
    if (!mounted) return;
    setState(() {
      _showTopScrollIndicator = _scrollController.offset > 20;
      _showBottomScrollIndicator = _scrollController.offset < 
        _scrollController.position.maxScrollExtent - 20;
    });
  }

  @override
  void didUpdateWidget(MenuOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    }

    // Close menu if vehicle is no longer parked
    if (!widget.vehicleState.isParked && widget.isVisible) {
      widget.onClose();
    }

    // Scroll to selected item if it's not visible
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final itemHeight = 70.0; // Approximate height of each menu item
        final targetOffset = widget.selectedIndex * itemHeight;
        const padding = 20.0;
        
        if (targetOffset < _scrollController.offset + padding ||
            targetOffset > _scrollController.offset + _scrollController.position.viewportDimension - padding) {
          _scrollController.animateTo(
            targetOffset - (_scrollController.position.viewportDimension / 2) + (itemHeight / 2),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Early return if not visible and animation is not running
    if (!widget.isVisible && _animController.isDismissed) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FadeTransition(
      opacity: _animation,
      child: Container(
        color: isDark 
            ? Colors.black.withOpacity(0.9) 
            : Colors.white.withOpacity(0.9),
        padding: const EdgeInsets.only(top: 40), // Leave space for top status bar
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'MENU',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            
            // Menu items with scroll indicators
            Expanded(
              child: Stack(
                children: [
                  // Menu items list
                  ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                    itemCount: widget.menuItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.menuItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: MenuItemWidget(
                          item: item,
                          isSelected: widget.selectedIndex == index,
                          isInSubmenu: widget.isInSubmenu && widget.selectedIndex == index,
                        ),
                      );
                    },
                  ),

                  // Top scroll indicator
                  if (_showTopScrollIndicator)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              isDark 
                                ? Colors.black.withOpacity(0.9)
                                : Colors.white.withOpacity(0.9),
                              isDark
                                ? Colors.black.withOpacity(0.0)
                                : Colors.white.withOpacity(0.0),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ),
                    ),

                  // Bottom scroll indicator
                  if (_showBottomScrollIndicator)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              isDark
                                ? Colors.black.withOpacity(0.9)
                                : Colors.white.withOpacity(0.9),
                              isDark
                                ? Colors.black.withOpacity(0.0)
                                : Colors.white.withOpacity(0.0),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Controls help
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlHint(
                    context,
                    'Left Brake',
                    widget.isInSubmenu ? 'Change Value' : 'Next Item',
                  ),
                  _buildControlHint(
                    context,
                    'Right Brake',
                    widget.isInSubmenu ? 'Confirm' : 'Select',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlHint(BuildContext context, String control, String action) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          control,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          action,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
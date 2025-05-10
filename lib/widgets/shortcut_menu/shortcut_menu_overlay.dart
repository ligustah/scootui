import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/shortcut_menu_cubit.dart';

class ShortcutMenuOverlay extends StatelessWidget {
  const ShortcutMenuOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShortcutMenuCubit, ShortcutMenuState>(
      builder: (context, state) {
        if (state == ShortcutMenuState.hidden) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<ShortcutMenuCubit>();
        final menuItems = cubit.menuItems;
        final isConfirming = cubit.isConfirming;

        // Use ValueListenableBuilder to listen to the selectedIndex changes
        return ValueListenableBuilder<int>(
          valueListenable: cubit.selectedIndexNotifier,
          builder: (context, selectedIndex, _) {
            print(
                'ShortcutMenuOverlay rebuilding with selectedIndex: $selectedIndex');

            return _buildMenuOverlay(
              context: context,
              menuItems: menuItems,
              selectedIndex: selectedIndex,
              isConfirming: isConfirming &&
                  state == ShortcutMenuState.confirmingSelection,
            );
          },
        );
      },
    );
  }

  Widget _buildMenuOverlay({
    required BuildContext context,
    required List<ShortcutMenuItem> menuItems,
    required int selectedIndex,
    required bool isConfirming,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 480,
      height: 480,
      color: Colors.black54,
      child: Stack(
        children: [
          // Menu items in a row at the bottom
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(menuItems.length, (index) {
                    final isSelected = index == selectedIndex;
                    return _buildMenuItem(
                      context: context,
                      item: menuItems[index],
                      isSelected: isSelected,
                      isDark: isDark,
                    );
                  }),
                ),
              ),
            ),
          ),

          // Confirmation UI
          if (isConfirming)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Press to trigger',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 1.0, end: 0.0),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            value: value,
                            backgroundColor:
                                isDark ? Colors.white24 : Colors.black12,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDark ? Colors.white : Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required ShortcutMenuItem item,
    required bool isSelected,
    required bool isDark,
  }) {
    // Add a print statement to debug when this is called
    print('Building menu item: $item, isSelected: $isSelected');

    final theme = Theme.of(context);
    final size = isSelected ? 80.0 : 60.0;
    final color = isSelected
        ? theme.colorScheme.primary
        : isDark
            ? Colors.white70
            : Colors.black54;

    // Add a key that depends on isSelected to force rebuild
    return AnimatedContainer(
      key: ValueKey(
          'menu_item_${item.name}_${isSelected ? 'selected' : 'normal'}'),
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Center(
        child: _getIconForMenuItem(item, color, isSelected ? 36 : 28),
      ),
    );
  }

  Widget _getIconForMenuItem(ShortcutMenuItem item, Color color, double size) {
    // Add a key to force rebuild when the size changes
    switch (item) {
      case ShortcutMenuItem.toggleHazards:
        return Icon(Icons.warning_amber_rounded,
            key: ValueKey('icon_hazards_$size'), color: color, size: size);
      case ShortcutMenuItem.toggleTheme:
        return Icon(Icons.brightness_6,
            key: ValueKey('icon_theme_$size'), color: color, size: size);
      case ShortcutMenuItem.toggleDebugOverlay:
        return Icon(Icons.bug_report,
            key: ValueKey('icon_debug_$size'), color: color, size: size);
      case ShortcutMenuItem.resetTrip:
        return Icon(Icons.refresh,
            key: ValueKey('icon_trip_$size'), color: color, size: size);
    }
  }
}

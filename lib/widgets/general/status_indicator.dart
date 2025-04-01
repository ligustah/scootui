import 'package:flutter/material.dart';

import '../../cubits/theme_cubit.dart';

class StatusIndicator extends StatelessWidget {
  final IconData icon;
  final bool active;
  final String label;
  final Color? color;
  final double iconSize;

  const StatusIndicator({
    super.key,
    required this.icon,
    required this.active,
    required this.label,
    this.color,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeState(:theme) = ThemeCubit.watch(context);
    final secondaryColor = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final iconColor = color ?? (active ? Colors.green : secondaryColor);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: iconColor,
          ),
        ),
      ],
    );
  }
}
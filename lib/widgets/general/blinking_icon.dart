import 'package:flutter/material.dart';

class BlinkingIcon extends StatefulWidget {
  final IconData icon;
  final bool isBlinking;
  final double size;
  final Color? blinkColor;
  final Color? inactiveColor;

  const BlinkingIcon({
    super.key,
    required this.icon,
    required this.isBlinking,
    this.size = 24,
    this.blinkColor,
    this.inactiveColor,
  });

  @override
  State<BlinkingIcon> createState() => _BlinkingIconState();
}

class _BlinkingIconState extends State<BlinkingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultInactiveColor = theme.textTheme.bodyMedium?.color ?? Colors.grey;
    final inactiveColor = widget.inactiveColor ?? defaultInactiveColor;
    final blinkColor = widget.blinkColor ?? Colors.green;

    if (!widget.isBlinking) {
      return Icon(
        widget.icon,
        size: widget.size,
        color: inactiveColor,
      );
    }

    return FadeTransition(
      opacity: _animation,
      child: Icon(
        widget.icon,
        size: widget.size,
        color: blinkColor,
      ),
    );
  }
}
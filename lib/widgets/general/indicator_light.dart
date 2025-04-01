import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_animations/simple_animations.dart';

typedef IndicatorIcon = Widget Function(
    Color color, double size);

class IndicatorLight extends StatelessWidget {
  static IndicatorIcon svgAsset(String iconName) {
    return (Color color, double size) => SvgPicture.asset(
          'assets/icons/$iconName',
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcIn,
          ),
          width: size,
          height: size,
        );
  }

  static IndicatorIcon iconData(IconData icon) {
    return (Color color, double size) => Icon(
          icon,
          color: color,
          size: size,
        );
  }

  final IndicatorIcon icon;
  final double size;
  final bool isActive;
  final bool blinking;
  final Color activeColor;
  final Color inactiveColor;

  const IndicatorLight({
    super.key,
    required this.icon,
    this.size = 24,
    this.isActive = true,
    this.blinking = false,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.white24,
  });

  @override
  Widget build(BuildContext context) {
    render(final Color color) => icon(color, size);

    return Stack(children: [
      render(isActive && !blinking ? activeColor : inactiveColor),
      if (blinking && isActive)
        MirrorAnimationBuilder(
          tween: IntTween(begin: 0, end: 255),
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 450),
          builder: (context, value, child) => render(activeColor.withAlpha(value)),
        ),
    ]);
  }
}

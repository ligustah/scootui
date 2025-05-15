import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../cubits/mdb_cubits.dart';

class SpeedLimitIndicator extends StatelessWidget {
  final double iconSize;
  final Color? iconColor;

  const SpeedLimitIndicator({
    Key? key,
    this.iconSize = 36,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final speedLimitData = SpeedLimitSync.watch(context);

    // Don't show anything if there's no speed limit data
    if (!speedLimitData.hasSpeedLimit || speedLimitData.iconName.isEmpty) {
      return const SizedBox.shrink();
    }

    // If using blank template, overlay text on the icon
    if (speedLimitData.iconName == "speedlimit_blank") {
      return Stack(
        alignment: Alignment.center,
        children: [
          // Base icon
          SvgPicture.asset(
            'assets/icons/speedlimit_blank.svg',
            width: iconSize,
            height: iconSize,
            colorFilter: iconColor != null ? ColorFilter.mode(iconColor!, BlendMode.srcIn) : null,
          ),

          // Text overlay
          // Scale font size proportionally to the icon size (64pt at 144px)
          Text(
            speedLimitData.value,
            style: GoogleFonts.robotoCondensed(
              fontWeight: FontWeight.bold,
              fontSize: iconSize * (64 / 144), // Scale proportionally
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // For pre-designed icons
    return SvgPicture.asset(
      'assets/icons/${speedLimitData.iconName}.svg',
      width: iconSize,
      height: iconSize,
      colorFilter: iconColor != null ? ColorFilter.mode(iconColor!, BlendMode.srcIn) : null,
    );
  }
}

class RoadNameDisplay extends StatelessWidget {
  final TextStyle? textStyle;

  const RoadNameDisplay({
    Key? key,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final speedLimitData = SpeedLimitSync.watch(context);

    // Don't show anything if there's no road name
    if (speedLimitData.roadName.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      speedLimitData.roadName,
      style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../cubits/mdb_cubits.dart';
import '../../cubits/theme_cubit.dart';
import '../../state/battery.dart';

// Battery icon dimensions (scaled from 144x144)
const double kBatteryIconWidth = 24.0;
const double kBatteryIconHeight = 24.0;

// Scale factor for converting from 144x144 to our icon size
const double kScaleFactor = kBatteryIconWidth / 144.0;

// Charge level rectangle dimensions (scaled from 144x144)
// Made larger: x-1, y-1, w+2, h+1
const double kChargeRectX = 23.0 * kScaleFactor;
const double kChargeRectY = 41.0 * kScaleFactor;
const double kChargeRectHeight = 83.0 * kScaleFactor;
const double kChargeRectMaxWidth = 98.0 * kScaleFactor;

// Fixed width for charge labels to prevent layout shifts
const double kChargeLabelWidth = 24.0;

class BatteryStatusDisplay extends StatelessWidget {
  final BatteryData battery;

  const BatteryStatusDisplay({super.key, required this.battery});

  @override
  Widget build(BuildContext context) {
    // Get theme information
    final ThemeState(:isDark) = ThemeCubit.watch(context);
    final iconColor = isDark ? Colors.white : Colors.black;
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = isDark ? Colors.black : Colors.white;

    // Determine which icon to show and what text to display
    Widget batteryIcon;
    String? labelText;

    if (!battery.present) {
      // Battery not present - show absent icon
      batteryIcon = SvgPicture.asset(
        'assets/icons/librescoot-main-battery-absent.svg',
        width: kBatteryIconWidth,
        height: kBatteryIconHeight,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    } else if (battery.state == BatteryState.asleep || battery.state == BatteryState.idle) {
      // Battery is asleep or idle - show normal charge icon with asleep mask and overlay
      final chargeWidth = (battery.charge / 100.0) * kChargeRectMaxWidth;

      batteryIcon = Stack(
        alignment: Alignment.center,
        children: [
          // Base battery icon with charge level
          Stack(
            alignment: Alignment.center,
            children: [
              // Base battery icon
              SvgPicture.asset(
                'assets/icons/librescoot-main-battery-blank.svg',
                width: kBatteryIconWidth,
                height: kBatteryIconHeight,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),

              // Charge level rectangle
              Positioned(
                left: kChargeRectX,
                top: kChargeRectY,
                child: Container(
                  width: chargeWidth,
                  height: kChargeRectHeight,
                  color: iconColor,
                ),
              ),
            ],
          ),

          // Apply asleep mask (draw inverted - mask areas in background color)
          SvgPicture.asset(
            'assets/icons/librescoot-main-battery-asleep-mask.svg',
            width: kBatteryIconWidth,
            height: kBatteryIconHeight,
            colorFilter: ColorFilter.mode(backgroundColor, BlendMode.srcIn),
          ),

          // Apply asleep overlay
          SvgPicture.asset(
            'assets/icons/librescoot-main-battery-asleep-overlay.svg',
            width: kBatteryIconWidth,
            height: kBatteryIconHeight,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ],
      );
      labelText = '${battery.charge}';
    } else if (battery.charge <= 10) {
      // Critically empty battery - show empty icon
      batteryIcon = SvgPicture.asset(
        'assets/icons/librescoot-main-battery-empty.svg',
        width: kBatteryIconWidth,
        height: kBatteryIconHeight,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
      labelText = '${battery.charge}';
    } else {
      // Normal battery with charge level - draw charge state as a block
      final chargeWidth = (battery.charge / 100.0) * kChargeRectMaxWidth;

      batteryIcon = Stack(
        alignment: Alignment.center,
        children: [
          // Base battery icon
          SvgPicture.asset(
            'assets/icons/librescoot-main-battery-blank.svg',
            width: kBatteryIconWidth,
            height: kBatteryIconHeight,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),

          // Charge level rectangle
          Positioned(
            left: kChargeRectX,
            top: kChargeRectY,
            child: Container(
              width: chargeWidth,
              height: kChargeRectHeight,
              color: iconColor,
            ),
          ),
        ],
      );
      labelText = '${battery.charge}';
    }

    // Return the battery icon with text label beside it
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        batteryIcon,
        if (labelText != null) ...[
          const SizedBox(width: 2),
          SizedBox(
            width: kChargeLabelWidth,
            child: Text(
              labelText,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -1.1,
                color: textColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class CombinedBatteryDisplay extends StatelessWidget {
  const CombinedBatteryDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final battery0 = Battery0Sync.watch(context);
    final battery1 = Battery1Sync.watch(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BatteryStatusDisplay(battery: battery0),
        const SizedBox(width: 8),
        BatteryStatusDisplay(battery: battery1),
      ],
    );
  }
}

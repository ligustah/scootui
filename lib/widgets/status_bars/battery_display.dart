import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../cubits/mdb_cubits.dart';
import '../../cubits/theme_cubit.dart';
import '../../state/aux_battery.dart';
import '../../state/battery.dart';
import '../../state/cb_battery.dart';
import '../../utils/toast_utils.dart';

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

class BatteryStatusDisplay extends StatelessWidget {
  final BatteryData battery;

  const BatteryStatusDisplay({super.key, required this.battery});

  @override
  Widget build(BuildContext context) {
    // Get theme information
    final ThemeState(:isDark) = ThemeCubit.watch(context);

    // Determine battery color based on charge level
    Color getBatteryColor() {
      if (battery.present) {
        if (battery.charge <= 10) {
          return const Color(0xFFFF0000); // Red for critical
        } else if (battery.charge <= 20) {
          return const Color(0xFFFF7900); // Orange for warning
        }
      }
      return isDark ? Colors.white : Colors.black; // Normal
    }

    final iconColor = getBatteryColor();
    final textColor = iconColor;
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
          Text(
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
        ],
      ],
    );
  }
}

class BatteryWarningIcon extends StatelessWidget {
  final String iconPath;
  final bool isDark;

  const BatteryWarningIcon({
    super.key,
    required this.iconPath,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDark ? Colors.white : Colors.black;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // Base battery blank icon
        SvgPicture.asset(
          iconPath,
          width: kBatteryIconWidth,
          height: kBatteryIconHeight,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        
        // Error overlay with built-in colors (white X on black circle)
        // Render with inversion for light theme to make it visible
        SvgPicture.asset(
          'assets/icons/librescoot-overlay-error.svg',
          width: kBatteryIconWidth,
          height: kBatteryIconHeight,
          colorFilter: !isDark 
              ? const ColorFilter.matrix([ // Invert colors for light theme
                  -1.0, 0.0, 0.0, 0.0, 255.0,
                  0.0, -1.0, 0.0, 0.0, 255.0,
                  0.0, 0.0, -1.0, 0.0, 255.0,
                  0.0, 0.0, 0.0, 1.0, 0.0,
                ])
              : null, // No filter for dark theme - use original colors
        ),
      ],
    );
  }
}

class BatteryWarningIndicators extends StatefulWidget {
  const BatteryWarningIndicators({super.key});

  @override
  State<BatteryWarningIndicators> createState() => _BatteryWarningIndicatorsState();
}

class _BatteryWarningIndicatorsState extends State<BatteryWarningIndicators> {
  bool _cbWarningShown = false;
  bool _auxLowChargeWarningShown = false;
  bool _auxLowVoltageWarningShown = false;
  bool _auxCriticalVoltageWarningShown = false;

  bool _shouldShowCbWarning(CbBatteryData cbBattery, BatteryData mainBattery) {
    final cbChargeOk = cbBattery.charge < 95;
    final cbNotCharging = cbBattery.chargeStatus == ChargeStatus.notCharging;
    final mainPresent = mainBattery.present;
    final mainNonZero = mainBattery.charge > 0;
    final mainActive = mainBattery.state == BatteryState.active;
    
    print('CB Warning Check: cbCharge=${cbBattery.charge} (<95: $cbChargeOk), cbStatus=${cbBattery.chargeStatus} (notCharging: $cbNotCharging), mainPresent=$mainPresent, mainCharge=${mainBattery.charge} (>0: $mainNonZero), mainState=${mainBattery.state} (active: $mainActive)');
    
    return cbChargeOk && cbNotCharging && mainPresent && mainNonZero && mainActive;
  }

  bool _shouldShowAuxLowChargeWarning(AuxBatteryData auxBattery, BatteryData mainBattery) {
    final auxLowCharge = auxBattery.charge <= 25;
    final auxNotCharging = auxBattery.chargeStatus == AuxChargeStatus.notCharging;
    final mainPresent = mainBattery.present;
    final mainNonZero = mainBattery.charge > 0;
    final mainActive = mainBattery.state == BatteryState.active;
    
    print('AUX Low Charge Warning Check: auxCharge=${auxBattery.charge} (<=25: $auxLowCharge), auxStatus=${auxBattery.chargeStatus} (notCharging: $auxNotCharging), mainPresent=$mainPresent, mainCharge=${mainBattery.charge} (>0: $mainNonZero), mainState=${mainBattery.state} (active: $mainActive)');
    
    return auxLowCharge && auxNotCharging && mainPresent && mainNonZero && mainActive;
  }

  bool _shouldShowAuxLowVoltageWarning(AuxBatteryData auxBattery) {
    final lowVoltage = auxBattery.voltage < 11500;
    final notCharging = auxBattery.chargeStatus == AuxChargeStatus.notCharging;
    
    print('AUX Low Voltage Warning Check: auxVoltage=${auxBattery.voltage} (<11500: $lowVoltage), auxStatus=${auxBattery.chargeStatus} (notCharging: $notCharging)');
    
    return lowVoltage && notCharging;
  }

  bool _shouldShowAuxCriticalVoltageWarning(AuxBatteryData auxBattery, BatteryData mainBattery) {
    final criticalVoltage = auxBattery.voltage < 11000; // 11.0V = 11000mV
    final mainPresent = mainBattery.present;
    
    print('AUX Critical Voltage Warning Check: auxVoltage=${auxBattery.voltage} (<11000: $criticalVoltage), mainPresent=$mainPresent');
    
    return criticalVoltage;
  }

  void _showToastIfNeeded(BuildContext context, String message, bool wasShown, Function(bool) setShown) {
    if (!wasShown && mounted) {
      ToastUtils.showWarningToast(context, message);
      setShown(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeState(:isDark) = ThemeCubit.watch(context);
    final cbBattery = CbBatterySync.watch(context);
    final auxBattery = AuxBatterySync.watch(context);
    final mainBattery = Battery0Sync.watch(context);

    final showCbWarning = _shouldShowCbWarning(cbBattery, mainBattery);
    final showAuxLowChargeWarning = _shouldShowAuxLowChargeWarning(auxBattery, mainBattery);
    final showAuxLowVoltageWarning = _shouldShowAuxLowVoltageWarning(auxBattery);
    final showAuxCriticalVoltageWarning = _shouldShowAuxCriticalVoltageWarning(auxBattery, mainBattery);
    final showAnyAuxWarning = showAuxLowChargeWarning || showAuxLowVoltageWarning || showAuxCriticalVoltageWarning;

    // Show toast notifications
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showCbWarning) {
        _showToastIfNeeded(context, "CB Battery not charging", _cbWarningShown, (shown) => _cbWarningShown = shown);
      } else {
        _cbWarningShown = false;
      }

      if (showAuxLowChargeWarning) {
        _showToastIfNeeded(context, "AUX Battery low and not charging", _auxLowChargeWarningShown, (shown) => _auxLowChargeWarningShown = shown);
      } else {
        _auxLowChargeWarningShown = false;
      }

      if (showAuxLowVoltageWarning) {
        _showToastIfNeeded(context, "AUX Battery voltage low", _auxLowVoltageWarningShown, (shown) => _auxLowVoltageWarningShown = shown);
      } else {
        _auxLowVoltageWarningShown = false;
      }

      if (showAuxCriticalVoltageWarning) {
        final message = mainBattery.present 
            ? "AUX Battery voltage very low - may need replacement"
            : "AUX Battery voltage very low - insert main battery to charge";
        _showToastIfNeeded(context, message, _auxCriticalVoltageWarningShown, (shown) => _auxCriticalVoltageWarningShown = shown);
      } else {
        _auxCriticalVoltageWarningShown = false;
      }
    });

    final List<Widget> warningIcons = [];
    
    if (showCbWarning) {
      warningIcons.add(
        BatteryWarningIcon(
          iconPath: 'assets/icons/librescoot-cb-battery-blank.svg',
          isDark: isDark,
        ),
      );
    }
    
    if (showAnyAuxWarning) {
      warningIcons.add(
        BatteryWarningIcon(
          iconPath: 'assets/icons/librescoot-aux-battery-blank.svg',
          isDark: isDark,
        ),
      );
    }

    if (warningIcons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < warningIcons.length; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          warningIcons[i],
        ],
        const SizedBox(width: 8), // Space after warning icons
      ],
    );
  }
}

class CombinedBatteryDisplay extends StatefulWidget {
  final bool showNonPresentBattery1;

  const CombinedBatteryDisplay({
    super.key,
    this.showNonPresentBattery1 = false,
  });

  @override
  State<CombinedBatteryDisplay> createState() => _CombinedBatteryDisplayState();
}

class _CombinedBatteryDisplayState extends State<CombinedBatteryDisplay> {
  int? _lastSoc;

  void _checkBatteryWarnings(int soc) {
    if (_lastSoc == null || _lastSoc == soc) {
      _lastSoc = soc;
      return;
    }

    // Only show toasts when crossing thresholds downward
    if (soc < _lastSoc!) {
      String? message;
      if (soc == 0 && _lastSoc! > 0) {
        message = "Battery empty. Recharge battery";
      } else if (soc < 5 && _lastSoc! >= 5) {
        message = "Max speed is reduced. Battery is below 5%";
      } else if (soc <= 10 && _lastSoc! > 10) {
        message = "Battery low. Power reduced. Please recharge battery";
      } else if (soc < 20 && _lastSoc! >= 20) {
        message = "Battery low. Power reduced. Recharge battery";
      }

      if (message != null && mounted) {
        ToastUtils.showWarningToast(context, message);
      }
    }

    _lastSoc = soc;
  }

  @override
  Widget build(BuildContext context) {
    final battery0 = Battery0Sync.watch(context); // battery:0 (main battery)
    final battery1 = Battery1Sync.watch(context);
    final ThemeState(:isDark) = ThemeCubit.watch(context);

    // Check for battery warnings
    _checkBatteryWarnings(battery0.charge);

    // Show turtle icon when battery is ≤10% (critical)
    final showTurtle = battery0.charge <= 10;
    final iconColor = isDark ? Colors.white : Colors.black;

    // Show battery:1 only if present or explicitly requested
    final showBattery1 = battery1.present || widget.showNonPresentBattery1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BatteryStatusDisplay(battery: battery0),
        if (showBattery1) ...[
          const SizedBox(width: 8),
          BatteryStatusDisplay(battery: battery1),
        ],
        const SizedBox(width: 8),
        const BatteryWarningIndicators(),
        if (showTurtle) ...[
          SvgPicture.asset(
            'assets/icons/librescoot-turtle-mode.svg',
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ],
      ],
    );
  }
}

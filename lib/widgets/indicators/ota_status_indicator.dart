import 'package:flutter/material.dart';

import '../../cubits/theme_cubit.dart';
import '../../cubits/mdb_cubits.dart';
import '../../state/vehicle.dart';
import 'indicator_light.dart';

class _Icons {
  static const String downloading = 'librescoot-ota-status-downloading.svg';
  static const String installing = 'librescoot-ota-status-installing.svg';
}

class OtaStatusIndicator extends StatelessWidget {
  const OtaStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicleState = VehicleSync.watch(context);
    final otaData = OtaSync.watch(context);
    final ThemeState(:isDark) = ThemeCubit.watch(context);
    
    // Check if DBC update is ongoing
    final dbcStatus = otaData.dbcStatus;
    final isOtaOngoing = dbcStatus == 'downloading' || dbcStatus == 'installing';
    
    // Only show when scooter is unlocked and DBC update is ongoing
    final isUnlocked = vehicleState.state == ScooterState.readyToDrive || 
                      vehicleState.state == ScooterState.parked;
    
    if (!isOtaOngoing || !isUnlocked) {
      return const SizedBox.shrink();
    }

    final color = isDark ? Colors.white : Colors.black;
    final updateVersion = otaData.dbcUpdateVersion;
    final actionText = dbcStatus == 'downloading' ? 'Downloading' : 'Installing';
    final versionText = updateVersion.isNotEmpty ? ' Librescoot $updateVersion' : ' update';

    return Tooltip(
      message: '$actionText$versionText',
      child: IndicatorLight(
        icon: IndicatorLight.svgAsset(dbcStatus == 'downloading' ? _Icons.downloading : _Icons.installing),
        isActive: true,
        size: 24.0,
        activeColor: color,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scooter_cluster/cubits/theme_cubit.dart';
import 'package:scooter_cluster/widgets/indicators/indicator_light.dart';

import '../../cubits/mdb_cubits.dart';
import '../../state/bluetooth.dart';
import '../../state/enums.dart';
import '../../state/gps.dart';
import '../../state/internet.dart';

class _Icons {
  static const String connected0 = 'librescoot-internet-modem-connected-0.svg';
  static const String connected1 = 'librescoot-internet-modem-connected-1.svg';
  static const String connected2 = 'librescoot-internet-modem-connected-2.svg';
  static const String connected3 = 'librescoot-internet-modem-connected-3.svg';
  static const String connected4 = 'librescoot-internet-modem-connected-4.svg';
  static const String diconnected =
      'librescoot-internet-modem-disconnected.svg';
  static const String off = 'librescoot-internet-modem-off.svg';
  static const String bluetoothConnected = 'librescoot-bluetooth-connected.svg';
  static const String bluetoothDisconnected =
      'librescoot-bluetooth-disconnected.svg';
  static const String cloudConnected =
      'librescoot-internet-cloud-connected.svg';
  static const String cloudDisconnected =
      'librescoot-internet-cloud-disconnected.svg';
  static const String gpsOff = 'librescoot-gps-off.svg';
  static const String gpsSearching = 'librescoot-gps-searching.svg';
  static const String gpsFixEstablished = 'librescoot-gps-fix-established.svg';
  static const String gpsError = 'librescoot-gps-error.svg';
}

final signalQuality = [
  (86, _Icons.connected4),
  (66, _Icons.connected3),
  (43, _Icons.connected2),
  (24, _Icons.connected1),
  (0, _Icons.connected0),
];

class ConnectivityIndicators extends StatelessWidget {
  const ConnectivityIndicators({super.key});

  String internetIcon(InternetData internet) {
    return switch (internet.status) {
      ConnectionStatus.disconnected => _Icons.diconnected,
      ConnectionStatus.connected => signalQuality
          .firstWhere((element) => internet.signalQuality >= element.$1)
          .$2
    };
  }

  String bluetoothIcon(BluetoothData bluetooth) {
    return switch (bluetooth.status) {
      ConnectionStatus.connected => _Icons.bluetoothConnected,
      ConnectionStatus.disconnected => _Icons.bluetoothDisconnected,
    };
  }

  String cloudIcon(InternetData internet) {
    return switch (internet.unuCloud) {
      ConnectionStatus.connected => _Icons.cloudConnected,
      ConnectionStatus.disconnected => _Icons.cloudDisconnected,
    };
  }

  String gpsIcon(GpsData gps) {
    return switch (gps.state) {
      GpsState.off => _Icons.gpsOff,
      GpsState.searching => _Icons.gpsSearching,
      GpsState.fixEstablished => _Icons.gpsFixEstablished,
      GpsState.error => _Icons.gpsError,
    };
  }

  @override
  Widget build(BuildContext context) {
    final internet = InternetSync.watch(context);
    final bluetooth = BluetoothSync.watch(context);
    final gps = GpsSync.watch(context);
    final ThemeState(:isDark) = ThemeCubit.watch(context);

    final color = isDark ? Colors.white : Colors.black;
    final size = 24.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 8,
      children: [
        IndicatorLight(
          icon: IndicatorLight.svgAsset(gpsIcon(gps)),
          isActive: true,
          size: size,
          activeColor: color,
        ),
        IndicatorLight(
            icon: IndicatorLight.svgAsset(bluetoothIcon(bluetooth)),
            isActive: true,
            size: size,
            activeColor: color),
        IndicatorLight(
            icon: IndicatorLight.svgAsset(cloudIcon(internet)),
            isActive: true,
            size: size,
            activeColor: color),
        IndicatorLight(
          icon: IndicatorLight.svgAsset(internetIcon(internet)),
          isActive: true,
          activeColor: color,
          size: size,
        ),
      ],
    );
  }
}

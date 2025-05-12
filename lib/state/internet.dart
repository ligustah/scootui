import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';
import 'enums.dart';

part 'internet.g.dart';

enum ModemState { off, disconnected, connected }

@StateClass("internet", Duration(seconds: 5))
class InternetData extends Equatable with $InternetData {
  @override
  @StateField(defaultValue: "off")
  final ModemState modemState;

  @override
  @StateField(defaultValue: "disconnected")
  final ConnectionStatus unuCloud;

  @override
  @StateField(defaultValue: "disconnected")
  final ConnectionStatus status;

  @override
  @StateField()
  final String ipAddress;

  // TODO: make this an enum once we figure out how to best overwrite the names
  //       since we can't use numbers as enum names (e.g. 2G, 3G, 4G)
  @override
  @StateField()
  final String accessTech;

  @override
  @StateField()
  final int signalQuality;

  @override
  @StateField()
  final String simImei;

  @override
  @StateField()
  final String simImsi;

  @override
  @StateField()
  final String simIccid;

  InternetData({
    this.status = ConnectionStatus.disconnected,
    this.accessTech = "",
    this.ipAddress = "",
    this.modemState = ModemState.off,
    this.signalQuality = 0,
    this.simIccid = "",
    this.simImei = "",
    this.unuCloud = ConnectionStatus.disconnected,
    this.simImsi = "",
  });
}

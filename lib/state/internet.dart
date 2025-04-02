import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';
import 'enums.dart';

part 'internet.g.dart';

enum ModemState { off, disconnected, connected }

@StateClass("internet", Duration(seconds: 5))
class InternetData extends Equatable with $InternetData {
  @StateField(defaultValue: "off")
  final ModemState modemState;

  @StateField(defaultValue: "disconnected")
  final ConnectionStatus unuCloud;

  @StateField(defaultValue: "disconnected")
  final ConnectionStatus status;

  @StateField()
  final String ipAddress;

  // TODO: make this an enum once we figure out how to best overwrite the names
  //       since we can't use numbers as enum names (e.g. 2G, 3G, 4G)
  @StateField()
  final String accessTech;

  @StateField()
  final int signalQuality;

  @StateField()
  final String simImei;

  @StateField()
  final String simImsi;

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

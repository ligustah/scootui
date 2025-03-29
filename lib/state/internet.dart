import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';
import 'enums.dart';

part 'internet.g.dart';

@StateClass("aux-battery", Duration(seconds: 5))
class InternetData extends Equatable with $InternetData {
  @StateField(defaultValue: "off")
  final Toggle modemState;

  @StateField(defaultValue: "disconnected")
  final ConnectionStatus unuCloud;

  @StateField(defaultValue: "disconnected")
  final ConnectionStatus status;

  @StateField()
  final String ipAddress;

  @StateField()
  final String accessTech;

  @StateField()
  final int signalQuality;

  @StateField()
  final String simImei;

  @StateField()
  final String simIccid;

  InternetData({
    this.status = ConnectionStatus.disconnected,
    this.accessTech = "",
    this.ipAddress = "",
    this.modemState = Toggle.off,
    this.signalQuality = 0,
    this.simIccid = "",
    this.simImei = "",
    this.unuCloud = ConnectionStatus.disconnected,
  });
}

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'ota.g.dart';

@StateClass("ota", Duration(seconds: 1))
class OtaData with $OtaData {
  @StateField(name: "status", defaultValue: "unknown")
  String otaStatus;

  @StateField(name: "update-type", defaultValue: "none")
  String updateType;

  @StateField(name: "status:dbc", defaultValue: "")
  String dbcStatus;

  OtaData({
    this.otaStatus = "none",
    this.updateType = "none",
    this.dbcStatus = "",
  });

}

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'ota.g.dart';

@StateClass("ota", Duration(seconds: 5))
class OtaData with $OtaData {
  @override
  @StateField(name: "status", defaultValue: "unknown")
  String otaStatus;

  @override
  @StateField(name: "update-type", defaultValue: "none")
  String updateType;

  @override
  @StateField(name: "status:dbc", defaultValue: "")
  String dbcStatus;

  @override
  @StateField(name: "status:mdb", defaultValue: "")
  String mdbStatus;

  OtaData({
    this.otaStatus = "none",
    this.updateType = "none",
    this.dbcStatus = "",
    this.mdbStatus = "",
  });
}

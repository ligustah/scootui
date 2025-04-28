import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'ota.g.dart';

@StateClass("ota", Duration(seconds: 1))
class OtaData with $OtaData {
  @StateField(name: "status", defaultValue: "unknown")
  String otaStatus;

  OtaData({
    this.otaStatus = "none",
  });
}

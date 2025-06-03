import 'package:scooter_cluster/builders/sync/annotations.dart';
import 'package:scooter_cluster/builders/sync/settings.dart';

part 'settings.g.dart';

@StateClass('settings', Duration(seconds: 5))
class SettingsData with $SettingsData implements Syncable<SettingsData> {
  @override
  @StateField(name: 'dashboard.show-raw-speed', defaultValue: 'false')
  String? showRawSpeed;

  // Constructor for initial values
  SettingsData({
    this.showRawSpeed,
  });

  // Factory for a completely initial state
  factory SettingsData.initial() => SettingsData();

  bool get showRawSpeedBool => showRawSpeed == 'true';
}
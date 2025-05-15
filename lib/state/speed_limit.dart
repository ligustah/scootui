import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'speed_limit.g.dart';

@StateClass("speed_limit", Duration(seconds: 5))
class SpeedLimitData extends Equatable with $SpeedLimitData {
  @override
  @StateField()
  final String value;

  @override
  @StateField()
  final String roadName;

  SpeedLimitData({
    this.value = "",
    this.roadName = "",
  });

  // Check if we have a valid speed limit to display
  bool get hasSpeedLimit => value.isNotEmpty;

  // Get the appropriate icon name based on the speed limit value
  String get iconName {
    if (!hasSpeedLimit) {
      return ""; // No icon when no speed limit data
    }

    try {
      final intValue = int.parse(value);

      // Return specific icon for exact matches
      if (intValue == 10) return "speedlimit_10";
      if (intValue == 20) return "speedlimit_20";
      if (intValue == 30) return "speedlimit_30";
      if (intValue == 40) return "speedlimit_40";
      if (intValue == 50) return "speedlimit_50";

      // Use ranges for non-exact matches
      if (intValue < 10) return "speedlimit_10"; // Will late user blank + custom text
      if (intValue < 20) return "speedlimit_10";
      if (intValue < 30) return "speedlimit_20";
      if (intValue < 40) return "speedlimit_30";
      if (intValue < 50) return "speedlimit_40";
      if (intValue == 50) return "speedlimit_50";

      return "speedlimit_over_50";
    } catch (e) {
      return "speedlimit_unknown";
    }
  }
}

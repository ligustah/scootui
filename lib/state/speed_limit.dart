import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'speed_limit.g.dart';

@StateClass("speed-limit", Duration(seconds: 5))
class SpeedLimitData extends Equatable with $SpeedLimitData {
  @override
  @StateField()
  final String value;

  @override
  @StateField()
  final String roadName;

  @override
  @StateField()
  final String roadType;

  SpeedLimitData({
    this.value = "",
    this.roadName = "",
    this.roadType = "",
  });

  // Check if we have a valid speed limit to display
  bool get hasSpeedLimit => value.isNotEmpty;

  // Get the appropriate icon name based on the speed limit value
  String get iconName {
    if (!hasSpeedLimit) {
      return ""; // No icon when no speed limit data
    }

    // Handle special string values
    if (value == "unknown" || value == "") {
      return ""; // No icon for unknown speed limit
    }

    if (value == "none") {
      return "speedlimit_none"; // Use none icon
    }

    try {
      int.parse(value);
      // Use the blank template with custom text
      return "speedlimit_blank";
    } catch (e) {
      return "speedlimit_unknown";
    }
  }
}

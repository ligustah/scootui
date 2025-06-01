import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'speed_limit.g.dart';

@StateClass("speed-limit", Duration(seconds: 5))
class SpeedLimitData extends Equatable with $SpeedLimitData {
  @override
  @StateField()
  final String speedLimit;

  @override
  @StateField()
  final String roadName;

  @override
  @StateField()
  final String roadType;

  SpeedLimitData({
    this.speedLimit = "",
    this.roadName = "",
    this.roadType = "",
  });

  // Check if we have a valid speed limit to display
  bool get hasSpeedLimit {
    if (speedLimit == "unknown" || speedLimit == "none" || speedLimit.isEmpty) {
      return false;
    }
    return true;
  }

  // Get the appropriate icon name based on the speed limit value
  String get iconName {
    if (!hasSpeedLimit) {
      return ""; // No icon when no speed limit data
    }

    // Handle special string values
    if (speedLimit == "unknown" || speedLimit == "") {
      return ""; // No icon for unknown speed limit
    }

    if (speedLimit == "none") {
      return "speedlimit_none"; // Use none icon
    }

    try {
      int.parse(speedLimit);
      // Use the blank template with custom text
      return "speedlimit_blank";
    } catch (e) {
      print("SpeedLimit iconName Exception: $e");
      return "speedlimit_unknown";
    }
  }
}

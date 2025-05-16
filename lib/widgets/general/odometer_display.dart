import 'package:flutter/material.dart';

import '../../cubits/theme_cubit.dart';
import '../indicators/speed_limit_indicator.dart';

class OdometerDisplay extends StatelessWidget {
  final double tripDistance;
  final double totalDistance;

  const OdometerDisplay({
    super.key,
    required this.tripDistance,
    required this.totalDistance,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Trip distance
              _DistanceDisplay(
                label: 'TRIP',
                value: _formatDistance(tripDistance),
                alignment: CrossAxisAlignment.start,
              ),

              // Total distance
              _DistanceDisplay(
                label: 'TOTAL',
                value: _formatDistance(totalDistance),
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ),

        // Road name absolutely positioned in center
        Positioned.fill(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200),
              child: RoadNameDisplay(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDistance(double distance) {
    return distance.toStringAsFixed(1);
  }
}

class _DistanceDisplay extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment alignment;

  const _DistanceDisplay({
    required this.label,
    required this.value,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeState(:theme, :isDark) = ThemeCubit.watch(context);

    // Format the distance value
    final parts = value.split('.');
    final whole = parts[0];
    final decimal = parts[1];

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label (TRIP or TOTAL)
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white60 : Colors.black54,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),

        // Distance value
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            // Whole number part
            Text(
              whole,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            // Decimal point
            Text(
              '.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            // Decimal part
            Text(
              decimal,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            // Unit (km)
            Text(
              'km',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TripDisplay extends StatelessWidget {
  const TripDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeState(:isDark) = ThemeCubit.watch(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Average speed
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('AVG SPEED', isDark),
              _buildValue('${_calculateAverageSpeed()} km/h', isDark),
            ],
          ),

          // Trip time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildLabel('TRIP TIME', isDark),
              _buildValue(_formatTripTime(), isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Builder(builder: (context) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white60 : Colors.black54,
          letterSpacing: 0.5,
        ),
      );
    });
  }

  Widget _buildValue(String text, bool isDark) {
    return Builder(builder: (context) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black,
        ),
      );
    });
  }

  double _calculateAverageSpeed() {
    // This would normally be calculated based on trip distance and time
    // For now, returning a placeholder value
    return 35.0;
  }

  String _formatTripTime() {
    // This would normally show the actual trip duration
    // For now, returning a placeholder value
    return '1:23';
  }
}

// Optional: Animated version of the odometer display
class AnimatedOdometerDisplay extends StatelessWidget {
  final double previousTrip;
  final double previousTotal;

  final double tripDistance;
  final double totalDistance;

  const AnimatedOdometerDisplay({
    super.key,
    required this.previousTrip,
    required this.previousTotal,
    required this.tripDistance,
    required this.totalDistance,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            tween: Tween<double>(
              begin: previousTrip,
              end: tripDistance,
            ),
            builder: (context, tripValue, child) {
              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(
                  begin: previousTotal,
                  end: totalDistance,
                ),
                builder: (context, totalValue, child) {
                  return OdometerDisplay(
                    tripDistance: tripValue,
                    totalDistance: totalValue,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

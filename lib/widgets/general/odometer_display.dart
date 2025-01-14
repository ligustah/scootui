import 'package:flutter/material.dart';
import '../../models/vehicle_state.dart';

class OdometerDisplay extends StatelessWidget {
  final VehicleState state;
  final double tripDistance;
  final double totalDistance;

  const OdometerDisplay({
    super.key,
    required this.state,
    required this.tripDistance,
    required this.totalDistance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
  final VehicleState state;

  const TripDisplay({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Average speed
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('AVG SPEED'),
              _buildValue('${_calculateAverageSpeed()} km/h'),
            ],
          ),
          
          // Trip time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildLabel('TRIP TIME'),
              _buildValue(_formatTripTime()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.black54,
            letterSpacing: 0.5,
          ),
        );
      }
    );
  }

  Widget _buildValue(String text) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
          ),
        );
      }
    );
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
  final VehicleState state;
  final double previousTrip;
  final double previousTotal;

  const AnimatedOdometerDisplay({
    super.key,
    required this.state,
    required this.previousTrip,
    required this.previousTotal,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(
        begin: previousTrip,
        end: state.tripDistance,
      ),
      builder: (context, tripValue, child) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 500),
          tween: Tween<double>(
            begin: previousTotal,
            end: state.odometerKm,
          ),
          builder: (context, totalValue, child) {
            return OdometerDisplay(
              state: state,
              tripDistance: tripValue,
              totalDistance: totalValue,
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/ota_cubit.dart';

/// A widget that displays OTA update information in a minimal way
/// Used in the cluster and map screens when in ready-to-drive mode
class OtaInfoWidget extends StatelessWidget {
  const OtaInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtaCubit, OtaState>(
      builder: (context, state) {
        return switch (state) {
          OtaInactive() => const SizedBox.shrink(), // No display when inactive
          OtaFullScreen() => const SizedBox.shrink(), // Should not happen in this widget
          OtaMinimal(:final statusText) => Positioned(
              bottom: 16, // Tiny bit of padding
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7), // Semi-transparent background
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16, // Font size 16 or so
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        };
      },
    );
  }
}

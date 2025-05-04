import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/ota_cubit.dart';

/// A dedicated screen for OTA updates that replaces the overlay approach
class OtaScreen extends StatelessWidget {
  const OtaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtaCubit, OtaState>(
      builder: (context, state) {
        return switch (state) {
          OtaInactive() => const SizedBox.shrink(), // Should not happen, but just in case
          OtaMinimal() => const SizedBox.shrink(), // Should not happen in this screen
          OtaFullScreen(:final status, :final statusText, :final isParked) => Container(
              color: isParked ? Colors.black.withOpacity(0.7) : Colors.black, // 70% opacity in parked, 100% otherwise
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      statusText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        };
      },
    );
  }
}

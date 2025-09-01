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
          OtaStatusBar() => const SizedBox.shrink(), // Should not happen in this screen
        };
      },
    );
  }
}

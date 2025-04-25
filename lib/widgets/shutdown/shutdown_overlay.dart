import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/shutdown_cubit.dart';
import 'shutdown_animation.dart'; // This import is still correct as the file name didn't change

class ShutdownOverlay extends StatelessWidget {
  const ShutdownOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final shutdownState = ShutdownCubit.watch(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: shutdownState.isVisible ? ShutdownContent(status: shutdownState.status) : const SizedBox.shrink(),
    );
  }
}

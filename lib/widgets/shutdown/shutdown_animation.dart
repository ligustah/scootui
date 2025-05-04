import 'package:flutter/material.dart';

import '../../cubits/shutdown_cubit.dart';

class ShutdownContent extends StatelessWidget {
  final ShutdownStatus status;

  const ShutdownContent({super.key, required this.status});

  String _getStatusText() {
    switch (status) {
      case ShutdownStatus.shuttingDown:
        return 'Shutting down...';
      case ShutdownStatus.suspending:
        return 'Suspending...';
      case ShutdownStatus.hibernatingImminent:
        return 'Hibernation imminent...';
      case ShutdownStatus.suspendingImminent:
        return 'Suspension imminent...';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (status == ShutdownStatus.hidden) {
      return const SizedBox.shrink();
    }

    final statusText = _getStatusText();

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spinner
              const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3.0,
                ),
              ),
              const SizedBox(height: 10), // Reduced spacing
              // Text
              Text(
                statusText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18, // Reduced font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

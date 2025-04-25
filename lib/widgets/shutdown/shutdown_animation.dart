import 'package:flutter/material.dart';

import '../../cubits/shutdown_cubit.dart';

class ShutdownContent extends StatelessWidget {
  final ShutdownStatus status;

  const ShutdownContent({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == ShutdownStatus.hidden) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: const Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 50.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spinner
              SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3.0,
                ),
              ),
              SizedBox(height: 10), // Reduced spacing
              // Text
              Text(
                'Shutting down...',
                style: TextStyle(
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

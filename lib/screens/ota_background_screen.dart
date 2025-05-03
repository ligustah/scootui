import 'package:flutter/material.dart';

/// A simple black background screen used during OTA updates
/// to avoid rendering expensive screens like Map in the background
class OtaBackgroundScreen extends StatelessWidget {
  const OtaBackgroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

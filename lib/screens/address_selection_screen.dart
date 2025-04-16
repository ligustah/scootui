import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/map_cubit.dart';
import '../cubits/mdb_cubits.dart';
import '../cubits/screen_cubit.dart';
import '../cubits/theme_cubit.dart';
import '../widgets/general/control_gestures_detector.dart';
import '../widgets/general/control_hints.dart';
import '../widgets/location_dial/location_dial.dart';

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({super.key});

  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  final _controller = LocationDialController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapCubit = context.read<MapCubit>();
    final screenCubit = context.read<ScreenCubit>();
    final ThemeState(:theme, :isDark) = ThemeCubit.watch(context);

    return ControlGestureDetector(
      stream: context.read<VehicleSync>().stream,
      onLeftPress: () => _controller.scroll(),
      onLeftHold: () => _controller.scroll(isLongPress: true),
      onLeftRelease: () => _controller.stopScroll(),
      onRightPress: () => _controller.next(),
      child: Container(
        width: 480,
        height: 480,
        color: theme.scaffoldBackgroundColor,
        padding: const EdgeInsets.only(top: 40, bottom: 40),
        child: Column(
          children: [
            _DialTitle(isDark: isDark),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocationDialInput(
                      length: 4,
                      controller: _controller,
                      onSubmit: (code) {
                        mapCubit.setDestinationAddress(code);
                        screenCubit.showMap();
                      },
                    ),
                  ],
                ),
              ),
            ),
            ControlHints(
              leftAction: 'Scroll',
              rightAction: 'Next',
            ),
          ],
        ),
      ),
    );
  }
}

class _DialTitle extends StatelessWidget {
  final bool isDark;

  const _DialTitle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Enter Destination Code',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }
}

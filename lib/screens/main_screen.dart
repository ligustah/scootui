import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/mdb_cubits.dart';
import '../cubits/menu_cubit.dart';
import '../cubits/screen_cubit.dart';
import '../widgets/general/control_gestures_detector.dart';
import '../widgets/menu/menu_overlay.dart';
import 'cluster_screen.dart';
import 'map_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ScreenCubit>().state;
    final menu = context.watch<MenuCubit>();

    return ControlGestureDetector(
      stream: context.read<VehicleSync>().stream,
      onLeftDoubleTap: () => menu.showMenu(),
      child: Stack(
        children: [
          SizedBox(
            width: 480,
            height: 480,
            child: switch (state) {
              ScreenMap() => const MapScreen(),
              ScreenCluster() => const ClusterScreen(),
            },
          ),

          // Menu overlay
          MenuOverlay(
            onThemeChanged: (mode) {},
          ),
        ],
      ),
    );
  }
}

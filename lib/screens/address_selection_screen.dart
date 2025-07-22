import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scooter_cluster/repositories/tile_address_repository.dart';

import '../cubits/address_cubit.dart';
// import '../cubits/navigation_cubit.dart'; // Not needed directly for setting destination via Redis
import '../cubits/mdb_cubits.dart';
import '../cubits/screen_cubit.dart';
import '../repositories/mdb_repository.dart';
import '../widgets/general/control_gestures_detector.dart';
import '../widgets/general/settings_screen.dart';
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

  Widget _buildDialInput(
      ScreenCubit screenCubit, TileAddressRepository addrService) {
    // Removed mapCubit
    return ControlGestureDetector(
      stream: context.read<VehicleSync>().stream,
      onLeftPress: () => _controller.scroll(),
      onLeftHold: () => _controller.scroll(isLongPress: true),
      onLeftRelease: () => _controller.stopScroll(),
      onRightPress: () => _controller.next(),
      child: LocationDialInput(
        length: 5,
        controller: _controller,
        onSubmit: (code) async {
          final address = await addrService.getLocation(code);
          if (address != null) {
            final mdbRepo = context.read<MDBRepository>();
            final coordinates = "${address.latitude},${address.longitude}";
            // Set destination via Redis, NavigationCubit will pick it up
            mdbRepo.set("navigation", "destination", coordinates);
            // context.read<NavigationCubit>().setDestination(address.coordinates); // Removed
          }
          screenCubit.showMap();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<ScreenCubit>();
    // final mapCubit = context.read<MapCubit>(); // Removed
    final addressCubit = context.watch<AddressCubit>();
    final addrService = context.read<TileAddressRepository>();

    final child = _buildDialInput(screenCubit, addrService);

    // final child = switch (addressCubit.state) {
    //   AddressStateLoaded(:final addresses) =>
    //     _buildDialInput(screenCubit, addresses), // Removed mapCubit
    //   AddressStateLoading(:final message) => Center(
    //         child: Column(
    //       children: [
    //         Text(message),
    //         const SizedBox(height: 16),
    //         const CircularProgressIndicator(),
    //       ],
    //     )),
    //   AddressStateError(:final message) => ControlGestureDetector(
    //       stream: context.read<VehicleSync>().stream,
    //       onRightPress: () => screenCubit.showMap(),
    //       child: Center(child: Text(message))),
    // };

    return SettingsScreen(
      title: 'Enter Destination Code',
      leftAction: switch (addressCubit.state) {
        AddressStateLoaded() => 'Scroll',
        _ => null,
      },
      rightAction: switch (addressCubit.state) {
        AddressStateLoaded() => 'Next',
        AddressStateError() => 'Close',
        _ => null,
      },
      child: child,
    );
  }
}

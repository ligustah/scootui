import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scooter_cluster/cubits/mdb_cubits.dart';
import 'package:scooter_cluster/widgets/general/control_gestures_detector.dart';

import '../location_dial/location_dial.dart';

class AddressSelection extends StatefulWidget {
  final void Function(String) onSubmit;
  final void Function() onCancel;
  final int length;

  const AddressSelection({
    super.key,
    required this.onSubmit,
    required this.onCancel,
    this.length = 4,
  });

  @override
  State<AddressSelection> createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  final _controller = LocationDialController();

  @override
  void initState() {
    super.initState();
    _controller.codeEvents.listen((code) {
      widget.onSubmit(code);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ControlGestureDetector(
      stream: context.read<VehicleSync>().stream,
      onLeftTap: () => _controller.scroll(),
      onLeftHold: () => _controller.scroll(isLongPress: true),
      onLeftRelease: () => _controller.stopScroll(),
      onRightPress: () => _controller.next(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LocationDialInput(
            length: widget.length,
            controller: _controller,
          ),
        ],
      ),
    );
  }
}

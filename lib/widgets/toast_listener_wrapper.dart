import 'dart:async';

import 'package:flutter/material.dart';

import '../services/toast_service.dart';
import '../utils/toast_utils.dart';

class ToastListenerWrapper extends StatefulWidget {
  final Widget child;

  const ToastListenerWrapper({super.key, required this.child});

  @override
  State<ToastListenerWrapper> createState() => _ToastListenerWrapperState();
}

class _ToastListenerWrapperState extends State<ToastListenerWrapper> {
  late StreamSubscription<ToastEvent> _toastSubscription;

  @override
  void initState() {
    super.initState();
    _toastSubscription = ToastService.events.listen((event) {
      if (mounted) {
        switch (event.type) {
          case ToastType.info:
            ToastUtils.showInfoToast(context, event.message);
            break;
          case ToastType.error:
            ToastUtils.showErrorToast(context, event.message);
            break;
          case ToastType.success:
            ToastUtils.showSuccessToast(context, event.message);
            break;
          case ToastType.warning:
            ToastUtils.showWarningToast(context, event.message);
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _toastSubscription.cancel();
    ToastService.dispose(); // Optional: Dispose the service stream if app is closing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

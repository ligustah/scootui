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
        // Ensure context is valid and available
        final currentContext = context;
        switch (event.type) {
          case ToastType.info:
            ToastUtils.showInfoToast(currentContext, event.message);
            break;
          case ToastType.error:
            ToastUtils.showErrorToast(currentContext, event.message);
            break;
          case ToastType.success:
            ToastUtils.showSuccessToast(currentContext, event.message);
            break;
          case ToastType.warning:
            // Assuming you'll add showWarningToast to ToastUtils
            // For now, let's use showInfoToast as a placeholder or create it
            // If showWarningToast doesn't exist, this will cause an error.
            // Consider adding it to ToastUtils.
            ToastUtils.showInfoToast(currentContext, event.message); // Placeholder
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

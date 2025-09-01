import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class ToastUtils {
  static void showToast(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.bottom,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? theme.colorScheme.surface.withOpacity(0.85);
    final effectiveTextColor = textColor ?? theme.colorScheme.onSurface;

    showToastWidget(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: effectiveTextColor,
            fontSize: 16.0,
          ),
        ),
      ),
      duration: duration,
      position: position,
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    final theme = Theme.of(context);
    showToast(
      context,
      message,
      backgroundColor: theme.colorScheme.errorContainer.withOpacity(0.9),
      textColor: theme.colorScheme.onErrorContainer,
      duration: const Duration(seconds: 3),
    );
  }

  static void showSuccessToast(BuildContext context, String message) {
    final theme = Theme.of(context);
    showToast(
      context,
      message,
      backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.9),
      textColor: theme.colorScheme.onPrimaryContainer,
      duration: const Duration(seconds: 2),
    );
  }

  static void showInfoToast(BuildContext context, String message) {
    final theme = Theme.of(context);
    showToast(
      context,
      message,
      backgroundColor: theme.colorScheme.secondaryContainer.withOpacity(0.9),
      textColor: theme.colorScheme.onSecondaryContainer,
      duration: const Duration(seconds: 2),
    );
  }

  static void showWarningToast(BuildContext context, String message) {
    final theme = Theme.of(context);
    showToast(
      context,
      message,
      backgroundColor: theme.colorScheme.secondaryContainer.withOpacity(0.9),
      textColor: theme.colorScheme.onSecondaryContainer,
      duration: const Duration(seconds: 3),
    );
  }

  static void showPersistentErrorToast(BuildContext context, String message) {
    final theme = Theme.of(context);
    showToast(
      context,
      message,
      backgroundColor: theme.colorScheme.errorContainer.withOpacity(0.9),
      textColor: theme.colorScheme.onErrorContainer,
      duration: const Duration(seconds: 10),
    );
  }
}

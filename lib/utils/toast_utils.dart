import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showToast(
    BuildContext context,
    String message, {
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color? backgroundColor,
    Color? textColor,
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? theme.colorScheme.surface.withOpacity(0.85);
    final effectiveTextColor = textColor ?? theme.colorScheme.onSurface;

    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: effectiveBackgroundColor,
      textColor: effectiveTextColor,
      fontSize: 16.0,
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    final theme = Theme.of(context);
    showToast(
      context,
      message,
      backgroundColor: theme.colorScheme.errorContainer.withOpacity(0.9),
      textColor: theme.colorScheme.onErrorContainer,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void showSuccessToast(BuildContext context, String message) {
    final theme = Theme.of(context);
    // Using primary container for success, adjust if a more specific success color is defined
    showToast(
      context,
      message,
      backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.9),
      textColor: theme.colorScheme.onPrimaryContainer,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void showInfoToast(BuildContext context, String message) {
    final theme = Theme.of(context);
    // Using secondary container for info, adjust if a more specific info color is defined
    showToast(
      context,
      message,
      backgroundColor: theme.colorScheme.secondaryContainer.withOpacity(0.9),
      textColor: theme.colorScheme.onSecondaryContainer,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void showWarningToast(BuildContext context, String message) {
    final theme = Theme.of(context);
    // Using a distinct color for warning, e.g., amber or orange if available in theme
    // For now, let's use secondary container as a fallback or define a specific warning color
    // in your theme.
    // You might want to define theme.colorScheme.warning and theme.colorScheme.onWarning
    showToast(
      context,
      message,
      backgroundColor: theme.colorScheme.secondaryContainer.withOpacity(0.9), // Placeholder, adjust
      textColor: theme.colorScheme.onSecondaryContainer, // Placeholder, adjust
      toastLength: Toast.LENGTH_LONG,
    );
  }
}

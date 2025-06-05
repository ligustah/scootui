import 'dart:async';

enum ToastType { info, error, success, warning }

class ToastEvent {
  final String message;
  final ToastType type;
  // Future: Add duration, gravity, etc. if needed

  ToastEvent(this.message, this.type);
}

class ToastService {
  // Private constructor to prevent instantiation
  ToastService._();

  static final _controller = StreamController<ToastEvent>.broadcast();
  static Stream<ToastEvent> get events => _controller.stream;

  static void showInfo(String message) {
    _controller.add(ToastEvent(message, ToastType.info));
  }

  static void showError(String message) {
    _controller.add(ToastEvent(message, ToastType.error));
  }

  static void showSuccess(String message) {
    _controller.add(ToastEvent(message, ToastType.success));
  }

  static void showWarning(String message) {
    _controller.add(ToastEvent(message, ToastType.warning));
  }

  // Call this in your main app's dispose or when no longer needed,
  // though for a global service, it might live for the app's lifetime.
  static void dispose() {
    _controller.close();
  }
}

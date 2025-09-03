/// A utility class for debouncing boolean conditions over time.
/// Only returns true after a condition has been consistently true for a specified duration.
class ConditionDebouncer {
  final Duration delay;
  DateTime? _conditionTrueStart;

  ConditionDebouncer({required this.delay});

  /// Updates the debouncer with the current condition state.
  /// Returns true only after the condition has been true for the full delay duration.
  bool update(bool condition) {
    final now = DateTime.now();

    if (condition) {
      // Condition is true - start or continue tracking
      _conditionTrueStart ??= now;
      
      // Check if enough time has passed
      return now.difference(_conditionTrueStart!) >= delay;
    } else {
      // Condition is false - reset tracking
      _conditionTrueStart = null;
      return false;
    }
  }

  /// Resets the debouncer state, clearing any tracked condition start time.
  void reset() {
    _conditionTrueStart = null;
  }

  /// Returns true if the condition is currently being tracked (true but not yet debounced).
  bool get isTracking => _conditionTrueStart != null;

  /// Returns the duration the condition has been true, or null if condition is false.
  Duration? get timeSinceConditionTrue {
    if (_conditionTrueStart == null) return null;
    return DateTime.now().difference(_conditionTrueStart!);
  }
}
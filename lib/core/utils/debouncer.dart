import 'dart:async';

import 'package:flutter/foundation.dart';

/// A utility class that debounces calls — delays execution until
/// [milliseconds] have passed since the last call.
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 300});

  /// Run [action] after the debounce delay.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancel any pending debounced call.
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose of the debouncer and cancel any pending call.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

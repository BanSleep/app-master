import 'dart:async';
import 'dart:ui';

class InputDelay {
  final int milliseconds;
  Timer? _timer;

  InputDelay({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

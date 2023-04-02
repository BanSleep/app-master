import 'package:cvetovik/models/api/response/base/time_range_base.dart';

mixin TimeIntervalMixin {
  String houseToString(int hour) {
    var raw = hour.toString();
    if (raw.length == 1) {
      raw = '0$raw';
    }
    raw = '$raw:00';
    return raw;
  }

  String getInterval(TimeRangeBase e) {
    var start = houseToString(e.startHour);
    var stop = houseToString(e.stopHour);
    return '$start-$stop';
  }
}

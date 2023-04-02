import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';

class TimeData {
  final bool extractTime;
  final String value;
  final TimeRangeData? data;
  TimeData(this.extractTime, this.value, this.data);
}

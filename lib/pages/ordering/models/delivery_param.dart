import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';

class DeliveryParam {
  final bool extractTime;
  final int price;
  final TimeRangeData? timeRange;
  DeliveryParam({
    required this.extractTime,
    required this.price,
    this.timeRange,
  });
}

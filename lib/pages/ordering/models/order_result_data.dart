import 'package:cvetovik/models/api/request/order_request.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/pages/ordering/models/map_position.dart';

class OrderResultData {
  final OrderRequest? request;
  final MapPosition? pos;
  final String error;
  final TimeRangeData? data;
  OrderResultData({this.request, this.pos, this.error = '', this.data});
}

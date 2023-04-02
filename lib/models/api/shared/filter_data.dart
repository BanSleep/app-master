import 'package:cvetovik/models/api/request/filter_request.dart';
import 'package:cvetovik/models/api/shared/prices.dart';

class FilterData {
  final List<FilterOptions>? filters;
  final Prices? prices;

  FilterData({this.filters, this.prices});
}

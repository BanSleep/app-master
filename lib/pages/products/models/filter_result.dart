import 'enum/filter_item_type.dart';

class FilterResult {
  final FilterItemType filterType;
  final Object data;

  FilterResult({required this.filterType, required this.data});
}

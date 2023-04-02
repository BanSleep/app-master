import 'package:cvetovik/models/api/request/filter_request.dart';
import 'package:cvetovik/pages/products/models/enum/sort/sort_direction.dart';
import 'package:cvetovik/pages/products/models/enum/sort/sort_field.dart';
import 'package:cvetovik/pages/products/models/enum/sort/sort_type.dart';
import 'package:enum_to_string/enum_to_string.dart';

mixin SortDataMixin {
  SortData getSort(SortType sortType) {
    String field;
    String direction;
    switch (sortType) {
      case SortType.upPrice:
        field = EnumToString.convertToString(SortField.price);
        direction = EnumToString.convertToString(SortDirection.up);
        break;
      case SortType.downPrice:
        field = EnumToString.convertToString(SortField.price);
        direction = EnumToString.convertToString(SortDirection.down);
        break;
      case SortType.upPop:
        field = EnumToString.convertToString(SortField.popularity);
        direction = EnumToString.convertToString(SortDirection.up);
        break;
      case SortType.downPop:
        field = EnumToString.convertToString(SortField.popularity);
        direction = EnumToString.convertToString(SortDirection.down);
        break;
    }
    var sortData = SortData(field: field, direction: direction);
    return sortData;
  }
}

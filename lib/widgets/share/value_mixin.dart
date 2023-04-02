import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:cvetovik/pages/ordering/models/address_full_data.dart';
import 'package:cvetovik/pages/ordering/models/enums/zones_delivery.dart';
import 'package:cvetovik/pages/ordering/models/order_result_data.dart';
import 'package:cvetovik/widgets/time/models/time_data.dart';
import 'package:tuple/tuple.dart';

mixin GetStrMixin {
  String value();
}

mixin TimeRangeUpdateMixin {
  void initTimeRanges();
}

mixin SetBoolMixin {
  bool value();
}

mixin GetOrderMixin {
  OrderResultData value();
}

mixin GetTimeMixin {
  TimeData value();
}

mixin GetAddressMixin {
  AddressFullData? value();
}

mixin SetAddressMixin {
  void initAddressValue(AddressFullData value);
}

mixin SetStrMixin {
  void initStrValue(String value);
}

mixin SetTimeRangeZoneMixin {
  void initTimeRangeValue(Tuple2<List<TimeRangeData>, ZonesDelivery> value);
}

mixin InitTimeRangeCourierMixin {
  void initTimeRangeValue(List<TimeRangeData> value);
}

mixin TimeIntervalValueCourierMixin {
  Tuple2<TimeRangeData, String>? value();
}

mixin SetTimeRangeSelfGetMixin {
  void initTimeRangeValueWithDt(DateTime value);
}

mixin GetTimeIntervalSelfGetMixin {
  Tuple2<ShopTimeRange, String> value();
}

mixin ClearValueMixin {
  Future<void> clear();
}

import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/models/api/response/catalog_response.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:cvetovik/models/api/response/suggestions_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_state.freezed.dart';

@freezed
class DeliveryState with _$DeliveryState {
  const factory DeliveryState.initializing() = _Initializing;
  const factory DeliveryState.loaded(DeliveryInfo data) =
  _Loaded;
  const factory DeliveryState.emptyData() = _EmptyData;
  const factory DeliveryState.error(String? text) = _Error;
}

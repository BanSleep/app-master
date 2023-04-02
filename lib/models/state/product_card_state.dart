import 'package:cvetovik/models/api/response/comments_response.dart';
import 'package:cvetovik/models/api/response/linked/linked_products_response.dart';
import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:cvetovik/models/api/response/region/region_info_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_card_state.freezed.dart';

@freezed
class ProductCardState with _$ProductCardState {
  const factory ProductCardState.initializing() = _Initializing;
  const factory ProductCardState.loaded(
      ProductCardResponse data,
      RegionInfo? info,
      Map<String, LinkedProduct>? linkedProducts,
      CommentData? comments) = _Loaded;
  const factory ProductCardState.error(String? text) = _Error;
  const factory ProductCardState.emptyData() = _EmptyData;
}

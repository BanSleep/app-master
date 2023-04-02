import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/api/response/region/region_info_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_state.freezed.dart';

@freezed
class ProductsState with _$ProductsState {
  const factory ProductsState.initializing() = _Initializing;
  const factory ProductsState.loaded(ProductsResponse data, RegionInfo? info,
      List<FavoriteData>? favorites,String? bannerText) = _Loaded;
  const factory ProductsState.error(String? text) = _Error;
  const factory ProductsState.emptyData() = _EmptyData;
  const factory ProductsState.searchProducts(
          ProductsResponse data, List<FavoriteData>? items, String search) =
      _SearchProducts;
}

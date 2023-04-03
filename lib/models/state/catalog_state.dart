import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/models/api/response/catalog_response.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:cvetovik/models/api/response/suggestions_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_state.freezed.dart';

@freezed
class CatalogState with _$CatalogState {
  const factory CatalogState.initializing() = _Initializing;
  const factory CatalogState.loaded(CatalogResponse data, List<Region> reg) =
      _Loaded;
  const factory CatalogState.searchProducts(
          ProductsResponse data, List<FavoriteData>? items, String search) =
      _SearchProducts;
  const factory CatalogState.emptyData() = _EmptyData;
  const factory CatalogState.error(String? text) = _Error;
  const factory CatalogState.suggestionsByText(SuggestionsResponse data) = _SuggestionsByText;
  const factory CatalogState.suggestions(List<dynamic> data) = _Suggestions;
}

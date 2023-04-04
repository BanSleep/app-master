import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/catalog_api.dart';
import 'package:cvetovik/core/api/home_api.dart';
import 'package:cvetovik/core/api/product_api.dart';
import 'package:cvetovik/core/db/dao/favorites_dao.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/services/providers/delivery_info_provider.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/state/catalog_state.dart';
import 'package:cvetovik/pages/products/mixin/sort_data_mixin.dart';
import 'package:cvetovik/pages/products/models/enum/sort/sort_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catalogModelProvider =
    StateNotifierProvider.family<CatalogModel, CatalogState, int>((ref, id) {
  var set = ref.read(settingsProvider);
  var api = ref.read(catalogApiProvider);
  var productApi = ref.read(productApiProvider);
  var dao = ref.read(favoritesDaoProvider);
  var homeApi = ref.read(homeApiProvider);

  return CatalogModel(
    set: set,
    api: api,
    parentId: id,
    productApi: productApi,
    favDao: dao,
    homeApi: homeApi,
  );
});

class CatalogModel extends StateNotifier<CatalogState> with SortDataMixin {
  final int parentId;
  final SettingsService set;
  final CatalogApi api;
  final ProductApi productApi;
  final FavoritesDao favDao;
  final HomeApi homeApi;

  CatalogModel({
    required this.set,
    required this.api,
    required this.parentId,
    required this.favDao,
    required this.homeApi,
    required this.productApi,
  }) : super(const CatalogState.initializing()) {
    load();
  }

  Future<void> load() async {
    DeviceRegisterAdd regData = set.getDeviceRegisterWithRegion();
    var clientInfo = set.getLocalClientInfo();

    try {
      var res = await api.getCatalogs(regData, parentId);
      if (res.result) {
        if (res.data != null) {
          var regItems = await homeApi.getRegions(regData, clientInfo);
          state = CatalogState.loaded(res, regItems.data.values.toList());
        } else {
          state = CatalogState.emptyData();
        }
      } else {
        state = CatalogState.error(AppRes.error);
      }
    } catch (e) {
      state = CatalogState.error(AppRes.error);
    }
  }

  String _searchText = '';
  SortType _sortType = SortType.downPop;

  SortType get sortType => _sortType;

  Future<void> search(String text) async {
    _searchText = text;
    if (text.isEmpty) {
      state = CatalogState.initializing();
      await load();
    } else {
      try {
        state = CatalogState.initializing();
        var regData = set.getDeviceRegisterWithRegion();
        var clientInfo = set.getLocalClientInfo();
        var res = await productApi.searchProducts(
            text, regData, getSort(sortType), clientInfo);
        var favorites = await favDao.getItems();
        state = CatalogState.searchProducts(res, favorites, text);
      } catch (e) {
        state = CatalogState.error(AppRes.error);
      }
    }
  }

  Future<void> getSuggestionsByText(String text) async {
    try {
      state = CatalogState.initializing();
      var reqData = set.getDeviceRegisterWithRegion();
      var clientInfo = set.getLocalClientInfo();
      var res = await productApi.getSuggestionsByText(text, reqData, clientInfo);
      state = CatalogState.suggestionsByText(res);
    } catch (e) {
      state = CatalogState.error(AppRes.error);
    }

  }
  Future<void> getSuggestions() async {
    try {
      state = CatalogState.initializing();
      var reqData = set.getDeviceRegisterWithRegion();
      var clientInfo = set.getLocalClientInfo();
      var res = await productApi.getSuggestions(reqData, clientInfo);
      state = CatalogState.suggestions(res);
    } catch (e) {
      state = CatalogState.error(AppRes.error);
    }

  }

  Future<void> applySort({required SortType sortType}) async {
    _sortType = sortType;
    await search(_searchText);
  }
}

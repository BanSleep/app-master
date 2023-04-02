import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/product_api.dart';
import 'package:cvetovik/core/db/dao/favorites_dao.dart';
import 'package:cvetovik/core/services/providers/catalog_data_provider.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/services/providers/region_info_provider.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/request/filter_request.dart';
import 'package:cvetovik/models/api/response/filter_reponse.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/api/shared/filter_data.dart';
import 'package:cvetovik/models/state/product_state.dart';
import 'package:cvetovik/pages/products/mixin/sort_data_mixin.dart';
import 'package:cvetovik/pages/products/models/enum/sort/sort_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsModelProvider =
    StateNotifierProvider.family<ProductsModel, ProductsState, int>(
        (ref, productId) {
  var set = ref.watch(settingsProvider);
  var api = ref.read(productApiProvider);
  var info = ref.watch(repositoryInfoProvider);
  var catalog = ref.watch(catalogDataProvider);
  var dao = ref.read(favoritesDaoProvider);
  var productApi = ref.read(productApiProvider);
  //ref.maintainState =true;
  return ProductsModel(
      set: set,
      api: api,
      id: productId,
      regionInfo: info,
      catalogProvider: catalog,
      favDao: dao,
      productApi: productApi);
});

class ProductsModel extends StateNotifier<ProductsState> with SortDataMixin {
  final int id;
  final SettingsService set;
  final ProductApi api;
  final CatalogsDataRepository catalogProvider;
  final RegionInfoRepository regionInfo;
  final FavoritesDao favDao;
  final ProductApi productApi;
  ProductsModel(
      {required this.id,
      required this.api,
      required this.set,
      required this.regionInfo,
      required this.catalogProvider,
      required this.favDao,
      required this.productApi})
      : super(const ProductsState.initializing()) {
    load();
  }

  Future<void> load({FilterRequest? filter}) async {
    var regData = set.getDeviceRegisterWithRegion();
    var clientInfo = set.getLocalClientInfo();
    var bannerText = await catalogProvider.getCatalogInfo(
        deviceRegister: regData, catalogId: id);

    print(bannerText.toString()+'banner141');
    
    ProductsResponse res;
    if (filter == null) {
      res = await catalogProvider.getCatalogData(
          deviceRegister: regData, catalogId: id);

    } else {
      res = await api.getProducts(
          deviceRegister: regData, parentId: id, filter: filter);
    }

    if (res.result) {
      if (filterData == null) {
        filterData = await api.getFilters(regData, id, clientInfo);
      }
      var info = await regionInfo.getRegionInfo(regData);
      var favorites = await favDao.getItems();
      state = ProductsState.loaded(res, info, favorites,bannerText);
    } else {
      state = ProductsState.error(AppRes.error);
    }
  }



  Future<void> search(String text) async {
    _searchText = text;
    if (text.isEmpty) {
      await load();
    } else {
      state = ProductsState.initializing();
      var regData = set.getDeviceRegisterWithRegion();
      var clientInfo = set.getLocalClientInfo();
      var favorites = await favDao.getItems();
      var res = await productApi.searchProducts(
          text, regData, getSort(_sortType), clientInfo);
      state = ProductsState.searchProducts(res, favorites, text);
    }
  }

  FilterResponse? filterData;
  Future<FilterResponse> getFilters() async {
    if (filterData == null || filterData!.data == null) {
      var regData = set.getDeviceRegisterWithRegion();
      var clientInfo = set.getLocalClientInfo();
      filterData = await api.getFilters(regData, id, clientInfo);
    }
    return filterData!;
  }

  Future<void> applyFilters({FilterData? filter, SortType? sort}) async {
    state = ProductsState.initializing();
    if (sort != null) {
      _sortType = sort;
    }
    //if(filter !=null)
    {
      _filter = filter;
    }
    FilterRequest filterData = _getFilterData();
    await load(filter: filterData);
  }

  Future<void> applySortForSearch(SortType sort) async {
    _sortType = sort;
    await search(_searchText);
  }

  String _searchText = '';
  SortType _sortType = SortType.downPop;
  SortType get sortType => _sortType;

  FilterData? _filter;
  FilterData? get filter => _filter;

  FilterRequest _getFilterData() {
    if (_filter != null) {
      var filter = FilterRequest(
          filters: (_filter!.filters ?? null),
          prices: (_filter!.prices ?? null),
          sort: getSort(_sortType));
      return filter;
    } else {
      return FilterRequest(
          filters: (null), prices: (null), sort: getSort(_sortType));
    }
  }
}

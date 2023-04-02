import 'package:collection/collection.dart';
import 'package:cvetovik/core/api/product_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/pages/products/models/catalog_result_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catalogDataProvider = Provider<CatalogsDataRepository>((ref) {
  var api = ref.read(productApiProvider);
  var set = ref.watch(settingsProvider);
  return CatalogsDataRepository(api, set);
});

class CatalogsDataRepository {
  final ProductApi api;
  final SettingsService set;
  List<CatalogResultData> _items = [];

  CatalogsDataRepository(this.api, this.set);



  Future<ProductData?> getProductData(int productId, int catalogId) async {
    var regData = set.getDeviceRegisterWithRegion();
    print("getting product data for region ${regData.toJson().toString()}");
    var data =
        await getCatalogData(deviceRegister: regData, catalogId: catalogId);
    if (data.result && data.data != null) {
      var curr = data.data!.firstWhereOrNull((el) => el.id == productId);
      return curr;
    }
    return null;
  }

  Future<ProductsResponse> getCatalogData(
      {required DeviceRegisterAdd deviceRegister,
      required int catalogId}) async {
    var curr = _items.firstWhereOrNull((element) => element.id == catalogId);
    if (curr == null) {
      var res = await api.getProducts(
          deviceRegister: deviceRegister, parentId: catalogId);
      if (res.result && res.data != null) {
        _items.add(CatalogResultData(id: catalogId, data: res.data!));
      }
      return res;
    } else {
      return ProductsResponse(result: true, data: curr.data);
    }
  }

  Future<String?> getCatalogInfo(
      {required  deviceRegister,
        required int catalogId}) async {
    var res = await api.getCatalogInfo(
        deviceRegister: deviceRegister, catalogId: catalogId);
    return res;

  }
}

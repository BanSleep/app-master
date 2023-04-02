import 'package:collection/collection.dart';
import 'package:cvetovik/core/api/catalog_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/linked/linked_decors_response.dart';
import 'package:cvetovik/models/api/response/linked/linked_products_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/provider/linked_decors_data.dart';
import 'package:cvetovik/models/provider/linked_products_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final linkedDataProvider = Provider<LinkedDataProvider>((ref) {
  var api = ref.read(catalogApiProvider);
  var set = ref.read(settingsProvider);
  return LinkedDataProvider(set, api);
});

class LinkedDataProvider {
  late List<LinkedProductData> _products;
  late List<LinkedDecorsData> _decors;

  final SettingsService set;
  final CatalogApi api;

  LinkedDataProvider(this.set, this.api) {
    _products = [];
    _decors = [];
  }

  Future<Map<String, LinkedDecor>?> getLinkedDecors(
      int catalogId, DeviceRegisterAdd regData) async {
    if (_decors.length > 0) {
      var curr = _decors.firstWhereOrNull(
          (el) => el.catalogId == catalogId && el.regionId == regData.regionId);
      if (curr != null) {
        return curr.decors;
      }
    }
    var clientInfo = set.getLocalClientInfo();
    var res = await api.getLinkedDecors(catalogId, regData, clientInfo);
    if (res != null) {
      _decors.add(LinkedDecorsData(
          catalogId: catalogId, regionId: regData.regionId, decors: res));
      return res;
    } else
      return null;
  }

  Future<Map<String, LinkedProduct>?> getLinkedProducts(
      int catalogId, DeviceRegisterAdd regData) async {
    if (_products.length > 0) {
      var curr = _products.firstWhereOrNull(
          (el) => el.catalogId == catalogId && el.regionId == regData.regionId);
      if (curr != null) {
        return curr.products;
      }
    }
    var clientInfo = set.getLocalClientInfo();
    var res = await api.getLinkedProducts(catalogId, regData, clientInfo);
    if (res != null) {
      _products.add(LinkedProductData(
          catalogId: catalogId, regionId: regData.regionId, products: res));
      return res;
    } else
      return null;
  }
}

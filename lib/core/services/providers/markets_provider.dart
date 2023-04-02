import 'package:collection/collection.dart';
import 'package:cvetovik/core/api/catalog_api.dart';
import 'package:cvetovik/core/api/markets_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/linked/linked_decors_response.dart';
import 'package:cvetovik/models/api/response/linked/linked_products_response.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/provider/linked_decors_data.dart';
import 'package:cvetovik/models/provider/linked_products_data.dart';
import 'package:cvetovik/pages/profile/markets/models/market_model.dart';
import 'package:cvetovik/pages/profile/markets/models/regions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketsProvider = Provider<MarketsProvider>((ref) {
  var api = ref.read(marketsApi);
  var set = ref.read(settingsProvider);
  return MarketsProvider(set, api);
});

class MarketsProvider {
  final SettingsService set;
  final MarketsApi api;

  MarketsProvider(this.set, this.api) {}

  Future<List<RegionModel>> getRegions() async {
    var clientInfo = set.getLocalClientInfo();
    var regData = set.getDeviceRegisterWithRegion();
    var res = await api.getRegions(regData, clientInfo);
    return res;
  }

  Future<String> getInfoText(String pageName) async {
    var clientInfo = set.getLocalClientInfo();
    var regData = set.getDeviceRegisterWithRegion();
    var res = await api.getInfoText(regData, clientInfo, pageName: pageName);
    return res;
  }
}

import 'package:collection/collection.dart';
import 'package:cvetovik/core/api/home_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/provider/region_shop_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shopsProvider = Provider<RegionShopRepository>((ref) {
  var api = ref.read(homeApiProvider);
  var set = ref.read(settingsProvider);
  return RegionShopRepository(set, api);
});

class RegionShopRepository {
  List<RegionShopData> _items = [];

  final SettingsService set;
  final HomeApi api;

  RegionShopRepository(this.set, this.api);

  Future<List<RegionShopInfo>?> getRegionShops(DeviceRegisterAdd data,{int? regionId}) async {
    var clientInfo = set.getLocalClientInfo();

    var curr = _items.firstWhereOrNull(
        (element) => element.regionId.toString() == data.regionId);
    if (curr != null&&regionId==null) {
      return curr.items;
    } else {
      try{
        var res = await api.getRegionShops(data, clientInfo,regionId: regionId);
        if (res.result && res.data != null) {
          var shops = res.data!.values.toList();
          var currInfo = RegionShopData(data.regionId, shops);
          _items.add(currInfo);
          return shops;
        }
      }catch(e){
        print(e.toString()+'shopError');
      }

    }
    return null;
  }
}

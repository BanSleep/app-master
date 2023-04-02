import 'package:collection/collection.dart';
import 'package:cvetovik/core/api/home_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/region/region_info_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final repositoryInfoProvider = Provider<RegionInfoRepository>((ref) {
  var set = ref.read(settingsProvider);
  var api = ref.read(homeApiProvider);
  return RegionInfoRepository(set, api);
});

class RegionInfoRepository {
  final SettingsService set;
  late List<RegionInfo> _items;
  final HomeApi api;
  RegionInfoRepository(this.set, this.api) {
    init();
  }

  void init() {
    _items = [];
  }

  Future<RegionInfo?> getRegionInfo(DeviceRegisterAdd data) async {
    RegionInfo? currInfo = _items
        .firstWhereOrNull((element) => element.id.toString() == data.regionId);
    var clientInfo = set.getLocalClientInfo();
    if (currInfo == null) {
      var res = await api.getRegionInfo(data, clientInfo);
      if (res.result && res.data != null) {
        _items.add(res.data!);
        return res.data;
      }else {
        return null;
      }

    } else {
      return currInfo;
    }

  }
}

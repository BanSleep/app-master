import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:cvetovik/core/api/home_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deliveryInfoProvider = Provider<DeliveryInfoRepository>((ref) {
  var api = ref.read(homeApiProvider);
  var set = ref.read(settingsProvider);
  return DeliveryInfoRepository(set, api);
});

class DeliveryInfoRepository {
  late List<DeliveryInfo> _items;

  final SettingsService set;
  final HomeApi api;

  void init() {
    _items = [];
  }

  DeliveryInfoRepository(this.set, this.api) {
    init();
  }

  Future<DeliveryInfo?> getDeliveryInfo(DeviceRegisterAdd data) async {
    DeliveryInfo? currInfo = _items
        .firstWhereOrNull((element) => element.id.toString() == data.regionId);
    if (currInfo == null) {
      var clientInfo = set.getLocalClientInfo();
      var res = await api.getDeliveryInfo(data, clientInfo);
      log("res: ${res.data!.timeRanges.toJson()}");
      if (res.result && res.data != null) {
        _items.add(res.data!);
        return res.data;
      }
    } else {
      return currInfo;
    }
    return null;
  }
}

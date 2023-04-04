import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:cvetovik/core/api/home_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/pages/products/mixin/sort_data_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/state/delivery_state.dart';

final deliveryInfoProvider = StateNotifierProvider<DeliveryInfoRepository, DeliveryState>((ref) {
  var api = ref.read(homeApiProvider);
  var set = ref.read(settingsProvider);
  return DeliveryInfoRepository(set, api);
});

class DeliveryInfoRepository extends StateNotifier<DeliveryState> with SortDataMixin {
  late List<DeliveryInfo> _items;

  final SettingsService set;
  final HomeApi api;

  void init() {
    _items = [];
  }

  DeliveryInfoRepository(this.set, this.api) : super(const DeliveryState.initializing()) {
    getDeliveryInfo();
  }

  Future<DeliveryInfo?> getDeliveryInfo() async {
    DeviceRegisterAdd data = set.getDeviceRegisterWithRegion();
    _items = [];
    DeliveryInfo? currInfo = _items
        .firstWhereOrNull((element) => element.id.toString() == data.regionId);
    if (currInfo == null) {
      var clientInfo = set.getLocalClientInfo();
      var res = await api.getDeliveryInfo(data, clientInfo);
      log("res: ${res.data!.timeRanges.toJson()}");
      if (res.result && res.data != null) {
        _items.add(res.data!);
        state = DeliveryState.loaded(res.data!);
        print(state);
        return res.data;
      }
    } else {

      state = DeliveryState.loaded(currInfo);
      return currInfo;
    }
    state = DeliveryState.error('Что-то пошло не так');
    return null;
  }

}

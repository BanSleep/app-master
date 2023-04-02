import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/cabinet_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/state/orders_state.dart';
import 'package:cvetovik/pages/products/mixin/sort_data_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ordersModelProvider =
    StateNotifierProvider<OrdersModel, OrdersState>((ref) {
  var set = ref.read(settingsProvider);
  var api = ref.read(cabinetApiProvider);

  return OrdersModel(
    set: set,
    api: api,
  );
});

class OrdersModel extends StateNotifier<OrdersState> with SortDataMixin {
  final SettingsService set;
  final CabinetApi api;

  OrdersModel({
    required this.set,
    required this.api,
  }) : super(const OrdersState.initializing()) {
    load();
  }

  Future<void> load() async {
    state = OrdersState.initializing();
    return reload();
  }

  Future<void> reload() async {
    try {
      DeviceRegisterAdd regData = set.getDeviceRegisterWithRegion();
      var localInfo = set.getLocalClientInfo();

      var res = await api.getOrders(regData, localInfo);
      if (res.result) {
        if (res.data!.isEmpty) {
          state = OrdersState.emptyData();
        } else {
          state = OrdersState.loaded(res.data!);
        }
      } else {
        state = OrdersState.error(AppRes.error);
      }
    } catch (e) {
      state = OrdersState.error(AppRes.error);
    }
  }
}

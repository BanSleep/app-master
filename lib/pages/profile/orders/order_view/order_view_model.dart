import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/cabinet_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/state/order_view_state.dart';
import 'package:cvetovik/pages/products/mixin/sort_data_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderViewModelProvider = StateNotifierProvider.autoDispose
    .family<OrderViewModel, OrderViewState, int>((ref, id) {
  var set = ref.read(settingsProvider);
  var api = ref.read(cabinetApiProvider);

  return OrderViewModel(
    id: id,
    set: set,
    api: api,
  );
});

class OrderViewModel extends StateNotifier<OrderViewState> with SortDataMixin {
  OrderViewModel({
    required this.id,
    required this.set,
    required this.api,
  }) : super(const OrderViewState.initializing()) {
    load();
  }

  final int id;
  final SettingsService set;
  final CabinetApi api;

  Future<void> load() async {
    state = OrderViewState.initializing();
    try {
      DeviceRegisterAdd regData = set.getDeviceRegisterWithRegion();
      var localInfo = set.getLocalClientInfo();

      var res = await api.getOrder(id, regData, localInfo);
      if (res.result) {
        state = OrderViewState.loaded(res.data!);
      } else {
        state = OrderViewState.error(AppRes.error);
      }
    } catch (e) {
      state = OrderViewState.error(AppRes.error);
    }
  }
}

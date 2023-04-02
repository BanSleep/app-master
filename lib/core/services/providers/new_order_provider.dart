import 'package:cvetovik/core/api/cabinet_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/request/order_request.dart';
import 'package:cvetovik/models/enums/app/set_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newOrderProvider = Provider<NewOrderProvider>((ref) {
  var set = ref.read(settingsProvider);
  var api = ref.read(cabinetApiProvider);
  return NewOrderProvider(
    api,
    set,
  );
});

class NewOrderProvider {
  final CabinetApi api;
  final SettingsService set;
  int _orderNumber = 0;
  NewOrderProvider(
    this.api,
    this.set,
  );

  Future<int> createOrder(OrderRequest req) async {
    var deviceRegister = set.getDeviceRegisterWithRegion();
    var localInfo = set.getLocalClientInfo();

    int? clientId = set.getData(SetKey.clientId);
    if (clientId != null && clientId > 0) {
      req.clientId = clientId.toString();
    }
    var orderNumber = await api.newOrder(
      deviceRegister,
      localInfo,
      req,
    );
    _orderNumber = orderNumber;
    return orderNumber;
  }

  Future<String> getPaymentWidget() async {
    var deviceRegister = set.getDeviceRegisterWithRegion();
    var localInfo = set.getLocalClientInfo();
    var res = await api.getPayWidget(_orderNumber, deviceRegister, localInfo);
    return res;
  }
}

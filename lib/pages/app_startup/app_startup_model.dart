import 'package:cvetovik/core/api/register_api.dart';
import 'package:cvetovik/core/db/dao/cart_dao.dart';
import 'package:cvetovik/core/services/device_info_service.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/enums/app/set_key.dart';
import 'package:cvetovik/models/state/app_startup_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appStartupModelProvider =
    StateNotifierProvider<AppStartupModel, AppStartupState>((ref) {
  var set = ref.read(settingsProvider);
  var api = ref.read(registerApiProvider);
  var deviceInfo = ref.read(deviceInfoProvider);
  var cartDao = ref.read(cartDaoProvider);
  return AppStartupModel(set, api, deviceInfo, cartDao);
});

class AppStartupModel extends StateNotifier<AppStartupState> {
  final SettingsService set;
  final RegisterApi api;
  final DeviceInfoService deviceInfo;
  final CartDao cartDao;
  AppStartupModel(this.set, this.api, this.deviceInfo, this.cartDao)
      : super(const AppStartupState.initializing()) {
    init();
  }

  Future<void> init() async {
    var isRegister = set.isDeviceRegister();
    await cartDao.getCartCount();
    if (!isRegister) {
      var deviceData = await deviceInfo.getDeviceInfo();
      var tokenData = await api.getTokenFromApi(deviceData);
      if (tokenData.error != null && tokenData.error!.isEmpty) {
        await set.setData<String>(SetKey.deviceToken, tokenData.token!);
        await set.setData<int>(SetKey.deviceId, tokenData.id);
        state = AppStartupState.loaded();
      } else {
        state = AppStartupState.error(tokenData.error);
      }
    } else
      state = AppStartupState.loaded();
  }
}

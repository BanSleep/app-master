import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/home_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/state/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeModelProvider = StateNotifierProvider<HomeModel, HomeState>((ref) {
  var set = ref.read(settingsProvider);
  var api = ref.read(homeApiProvider);
  return HomeModel(
    set,
    api,
  );
});

class HomeModel extends StateNotifier<HomeState> {
  final SettingsService set;
  final HomeApi api;
  HomeModel(this.set, this.api) : super(const HomeState.initializing()) {
    init();
  }

  Future<void> init() async {
    var regData = set.getDeviceRegister();
    var clientInfo = set.getLocalClientInfo();
    try {
      var res = await api.getRegions(regData, clientInfo);
      if (res.result)
        state = HomeState.loaded(res);
      else {
        state = HomeState.error(AppRes.error);
      }
    } catch (e) {
      state = HomeState.error(AppRes.error);
    }
  }
}

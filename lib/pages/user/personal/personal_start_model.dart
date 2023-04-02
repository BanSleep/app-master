import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/cabinet_api.dart';
import 'package:cvetovik/core/api/home_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/enums/app/set_key.dart';
import 'package:cvetovik/models/state/personal_start_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personalStartModelProvider =
    StateNotifierProvider<PersonalStartModel, PersonalStartState>((ref) {
  var set = ref.read(settingsProvider);
  var homeApi = ref.read(homeApiProvider);
  var cabinetApi = ref.read(cabinetApiProvider);
  return PersonalStartModel(set, homeApi, cabinetApi);
});

class PersonalStartModel extends StateNotifier<PersonalStartState> {
  final SettingsService set;
  final HomeApi homeApi;
  final CabinetApi cabinetApi;

  PersonalStartModel(
    this.set,
    this.homeApi,
    this.cabinetApi,
  ) : super(const PersonalStartState.initializing()) {
    init();
  }

  Future<void> init() async {
    var regData = set.getDeviceRegister();
    var clientInfo = set.getLocalClientInfo();
    var res = await homeApi.getRegions(regData, clientInfo);
    if (res.result) {
      var localInfo = set.getLocalClientInfo();
      var info = await cabinetApi.getClientInfo(regData, localInfo);

      if (!info.result) {
        await set.setData<String>(
          SetKey.clientToken,
          '',
        );

        await set.setData<int>(SetKey.clientId, 0);
        state = PersonalStartState.loaded(res, info);
      } else {
        state = PersonalStartState.loaded(res, info);
      }
    } else {
      state = PersonalStartState.error(AppRes.error);
    }
  }
}

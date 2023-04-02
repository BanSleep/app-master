import 'package:cvetovik/core/api/cabinet_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/cabinet/activate_bonus_card_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bonusCardModelProvider = Provider<BonusCardModel>((ref) {
  var set = ref.read(settingsProvider);
  var api = ref.read(cabinetApiProvider);

  return BonusCardModel(
    set: set,
    api: api,
  );
});

class BonusCardModel {
  final SettingsService set;
  final CabinetApi api;

  BonusCardModel({required this.set, required this.api});

  Future<ActivateBonusCardResponse> activateBonusCard(
      ActivateBonusCardModel data) {
    var regData = set.getDeviceRegister();
    var localInfo = set.getLocalClientInfo();
    return api.activateBonusCard(data, regData, localInfo);
  }
}

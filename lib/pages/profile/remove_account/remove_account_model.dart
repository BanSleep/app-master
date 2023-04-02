import 'dart:async';

import 'package:cvetovik/core/api/cabinet_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/cabinet/check_code_response.dart';
import 'package:cvetovik/models/api/response/shared/simple_response.dart';
import 'package:cvetovik/models/enums/app/set_key.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final removeAccountModelProvider =
    ChangeNotifierProvider<RemoveAccountModel>((ref) {
  var set = ref.read(settingsProvider);
  var api = ref.read(cabinetApiProvider);
  return RemoveAccountModel(
    set: set,
    api: api,
  );
});

class RemoveAccountModel with ChangeNotifier {
  bool smsIsAlreadySended = false;
  Duration durationForRepeatSendSms = Duration();

  RemoveAccountModel({required this.set, required this.api});

  final SettingsService set;
  final CabinetApi api;

  Future<SimpleResponse> sendSms() async {
    var regData = set.getDeviceRegisterWithRegion();
    var clientInfo = set.getLocalClientInfo();
    var res = api.sendSmsRemoveAccount(regData, clientInfo, _saveCookie);
    return res;
  }

  void sendSmsAgain() {
    if (smsIsAlreadySended) {
      return;
    }
    smsIsAlreadySended = true;
    durationForRepeatSendSms = Duration(seconds: 40);
    notifyListeners();

    sendSms();

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (durationForRepeatSendSms.inSeconds == 0) {
        smsIsAlreadySended = false;
        notifyListeners();
        return timer.cancel();
      }

      durationForRepeatSendSms -= Duration(seconds: 1);
      notifyListeners();
    });
  }

  Future<CheckCodeResponse> checkCode({required String code}) async {
    var regData = set.getDeviceRegisterWithRegion();
    var clientInfo = set.getLocalClientInfo();
    String? cookie = set.getData(SetKey.cookie);

    if (cookie != null) {
      var res =
          await api.checkCodeRemoveAccount(code, regData, clientInfo, cookie);
      if (res.result) {
        await set.setData<String>(SetKey.clientToken, '');
        await set.setData<int>(SetKey.clientId, 0);
      }
      return res;
    } else {
      return CheckCodeResponse(result: false);
    }
  }

  Future<void> _saveCookie(String cookie) async {
    await set.setData<String>(SetKey.cookie, cookie);
    print(cookie);
  }
}

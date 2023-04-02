import 'dart:async';

import 'package:cvetovik/core/api/cabinet_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/cabinet/check_code_response.dart';
import 'package:cvetovik/models/api/response/shared/simple_response.dart';
import 'package:cvetovik/models/enums/app/set_key.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authNumberModelProvider = ChangeNotifierProvider<AuthNumberModel>((ref) {
  var set = ref.read(settingsProvider);
  var api = ref.read(cabinetApiProvider);
  return AuthNumberModel(
    set: set,
    api: api,
  );
});

class AuthNumberModel with ChangeNotifier {
  bool smsIsAlreadySended = false;
  Duration durationForRepeatSendSms = Duration();

  AuthNumberModel({required this.set, required this.api});

  final SettingsService set;
  final CabinetApi api;

  Future<SimpleResponse> sendSms(String phone) async {
    var regData = set.getDeviceRegisterWithRegion();
    var res = api.sendSms(phone, regData, _saveCookie);
    return res;
  }

  void sendSmsAgain(String phone) {
    if (smsIsAlreadySended) {
      return;
    }
    smsIsAlreadySended = true;
    durationForRepeatSendSms = Duration(seconds: 40);
    notifyListeners();

    sendSms(phone);

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

  Future<CheckCodeResponse> checkCode(
      {required String phone, required String code}) async {
    var regData = set.getDeviceRegisterWithRegion();
    String? cookie = set.getData(SetKey.cookie);
    if (cookie != null) {
      var res = await api.checkCode(phone, code, regData, cookie);
      if (res.result && res.data != null) {
        try {
          await set.setData<String>(SetKey.clientToken, res.data!.token);
          await set.setData<int>(SetKey.clientId, res.data!.id);
          print('code ok');
        } catch (e) {
          print(e);
        }
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

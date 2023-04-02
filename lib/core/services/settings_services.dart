import 'package:cvetovik/models/api/shared/device_register.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/api/shared/local_client_info.dart';
import 'package:cvetovik/models/enums/app/set_key.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsProvider = ChangeNotifierProvider<SettingsService>(
    (ref) => throw UnimplementedError());

class SettingsService with ChangeNotifier {
  final SharedPreferences pref;

  SettingsService(this.pref);

  Future<void> setData<T>(SetKey key, dynamic value) async {
    String strKey = EnumToString.convertToString(key);
    await _setData<T>(strKey, value);
  }

  dynamic getData(SetKey key) {
    var type = _getTypeByKey(key);
    String strKey = EnumToString.convertToString(key);
    switch (type) {
      case String:
        var res = pref.getString(strKey) ?? '';
        print("res: $res");
        return res;
      case int:
        return pref.getInt(strKey);
      case double:
        return pref.getDouble(strKey) ?? 0;
      case bool:
        return pref.getBool(strKey) ?? false;
      default:
        throw ('Settings type not find');
    }
  }

  Type _getTypeByKey(SetKey key) {
    switch (key) {
      case SetKey.isDarkMode:
        return bool;
      case SetKey.deviceToken:
      case SetKey.cookie:
      case SetKey.clientToken:
      case SetKey.authToken:
      case SetKey.regionTitle:
      case SetKey.clientToken:
        return String;
      case SetKey.regionId:
      case SetKey.deviceId:
      case SetKey.clientId:
        return int;
      default:
        throw ('Settings key not find');
    }
  }

  Future<void> _setData<T>(String strKey, T value) async {
    switch (T) {
      case String:
        await pref.setString(strKey, value as String);
        break;
      case int:
        await pref.setInt(strKey, value as int);
        break;
      case bool:
        await pref.setBool(strKey, value as bool);
        break;
      case double:
        await pref.setDouble(strKey, value as double);
        break;
      default:
        break;
    }

    notifyListeners();
  }

  bool isDeviceRegister() {
    String? token = getData(SetKey.deviceToken);
    int? deviceId = getData(SetKey.deviceId);

    return (token?.isNotEmpty ?? false) && (deviceId != null && deviceId > 0);
  }

  DeviceRegister getDeviceRegister() {
    var deviceId = getData(SetKey.deviceId);
    var token = getData(SetKey.deviceToken);
    return DeviceRegister(deviceId.toString(), token.toString());
  }

  DeviceRegisterAdd getDeviceRegisterWithRegion({int? regionId}) {
    var deviceId = getData(SetKey.deviceId);
    var token = getData(SetKey.deviceToken);
    if (regionId == null) {
      regionId = getCurrentRegionId();
    } else {
      //nothing
    }
    print("actual region id: $regionId");
    return DeviceRegisterAdd(
        deviceId.toString(), token.toString(), regionId.toString());
  }

  LocalClientInfo getLocalClientInfo() {
    var id = getData(SetKey.clientId);
    var token = getData(SetKey.clientToken);
    return LocalClientInfo(id, token);
  }

  bool isAuthorized() {
    String? token = getData(SetKey.clientToken);
    int? clientId = getData(SetKey.clientId);

    return (token?.isNotEmpty ?? false) && (clientId != null && clientId > 0);
  }

  int? getTrueCurrentRegionId() {
    int? regionId = getData(SetKey.regionId);
    return regionId;
  }

  int getCurrentRegionId() {
    int regionId = getData(SetKey.regionId) ?? 1;
    return regionId;
  }

  String getCurrentRegionTitle() {
    String regionTitle = getData(SetKey.regionTitle);
    if (regionTitle.isEmpty) {
      regionTitle = 'Санкт-Петербург';
    }
    return regionTitle;
  }
}

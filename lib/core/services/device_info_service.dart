import 'dart:io';

import 'package:cvetovik/models/app/app_device_model.dart';
import 'package:cvetovik/models/enums/app/os_type.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceInfoProvider =
    Provider<DeviceInfoService>((ref) => DeviceInfoService());

class DeviceInfoService {
  Future<AppDeviceInfo> getDeviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return AppDeviceInfo(
          id: iosDeviceInfo.identifierForVendor,
          model: iosDeviceInfo.model,
          os: OsType.iOS);
      //;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return AppDeviceInfo(
          id: androidDeviceInfo.androidId,
          model: androidDeviceInfo.model,
          os: OsType.Android);
    }
  }
}

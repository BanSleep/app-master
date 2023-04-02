import 'package:cvetovik/models/api/shared/device_register.dart';

class DeviceRegisterAdd extends DeviceRegister {
  String regionId;
  DeviceRegisterAdd(String deviceId, String token, this.regionId)
      : super(deviceId, token);

  Map<String, String> toJson() =>
      {"device_id": deviceId, "device_token": token, "region_id": regionId};
}

class DeviceRegister {
  final String deviceId;
  final String token;

  DeviceRegister(this.deviceId, this.token);

  Map<String, String> toJson() => {
        "device_id": deviceId,
        "device_token": token,
      };
}

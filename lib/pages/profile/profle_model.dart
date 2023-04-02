import 'package:cvetovik/core/api/cabinet_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/cabinet/edit_profile_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileModelProvider = Provider<ProfileModel>((ref) {
  var set = ref.read(settingsProvider);
  var api = ref.read(cabinetApiProvider);

  return ProfileModel(
    set: set,
    api: api,
  );
});

class ProfileModel {
  final SettingsService set;
  final CabinetApi api;

  ProfileModel({required this.set, required this.api});

  Future<EditProfileResponse> editProfile(EditProfileModel data) async {
    var regData = set.getDeviceRegister();
    var localInfo = set.getLocalClientInfo();
    return await api.editProfile(data, regData, localInfo);
  }
}

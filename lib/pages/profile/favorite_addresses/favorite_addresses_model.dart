import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/cabinet_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/cabinet/favorite_address_list_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/state/favorite_addresses_state.dart';
import 'package:cvetovik/pages/products/mixin/sort_data_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteAddressesModelProvider = StateNotifierProvider.autoDispose<
    FavoriteAddressesViewModel, FavoriteAddressesState>((ref) {
  var set = ref.read(settingsProvider);
  var api = ref.read(cabinetApiProvider);

  return FavoriteAddressesViewModel(
    set: set,
    api: api,
  );
});

class FavoriteAddressesViewModel extends StateNotifier<FavoriteAddressesState>
    with SortDataMixin {
  FavoriteAddressesViewModel({
    required this.set,
    required this.api,
  }) : super(const FavoriteAddressesState.initializing()) {
    load();
  }

  final SettingsService set;
  final CabinetApi api;

  Future<void> load() async {
    state = FavoriteAddressesState.initializing();
    try {
      DeviceRegisterAdd regData = set.getDeviceRegisterWithRegion();
      var localInfo = set.getLocalClientInfo();

      var res = await api.getFavoriteAddresses(regData, localInfo);
      if (res.result) {
        if (res.data!.isEmpty) {
          state = FavoriteAddressesState.emptyData();
        } else {
          state = FavoriteAddressesState.loaded(res.data!);
        }
      } else {
        state = FavoriteAddressesState.error(AppRes.error);
      }
    } catch (e) {
      state = FavoriteAddressesState.error(AppRes.error);
    }
  }

  Future<Exception?> addAddress(AddFavoriteAddressRequest request) async {
    try {
      DeviceRegisterAdd regData = set.getDeviceRegisterWithRegion();
      var localInfo = set.getLocalClientInfo();

      var res = await api.addFavoriteAddress(request, regData, localInfo);
      if (!res.result) {
        return Exception(res.errors);
      }
    } catch (e) {
      return e as Exception;
    }

    return null;
  }

  Future<Exception?> editAddress(
    int addressId,
    EditFavoriteAddressRequest request,
  ) async {
    try {
      DeviceRegisterAdd regData = set.getDeviceRegisterWithRegion();
      var localInfo = set.getLocalClientInfo();

      var res =
          await api.editFavoriteAddress(addressId, request, regData, localInfo);
      if (!res.result) {
        return Exception(res.errors);
      }
    } catch (e) {
      return e as Exception;
    }

    return null;
  }

  Future<Exception?> deleteAddress(int addressId) async {
    try {
      DeviceRegisterAdd regData = set.getDeviceRegisterWithRegion();
      var localInfo = set.getLocalClientInfo();

      var res = await api.deleteFavoriteAddress(addressId, regData, localInfo);
      if (!res.result) {
        return Exception(res.errors);
      }
    } catch (e) {
      return e as Exception;
    }

    return null;
  }
}

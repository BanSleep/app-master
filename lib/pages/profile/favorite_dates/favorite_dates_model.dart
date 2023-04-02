import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/cabinet_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/cabinet/favorite_date_list_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/state/favorite_dates_state.dart';
import 'package:cvetovik/pages/products/mixin/sort_data_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteDatesModelProvider =
    StateNotifierProvider<FavoriteDatesViewModel, FavoriteDatesState>((ref) {
  var set = ref.read(settingsProvider);
  var api = ref.read(cabinetApiProvider);

  return FavoriteDatesViewModel(
    set: set,
    api: api,
  );
});

class FavoriteDatesViewModel extends StateNotifier<FavoriteDatesState>
    with SortDataMixin {
  FavoriteDatesViewModel({
    required this.set,
    required this.api,
  }) : super(const FavoriteDatesState.initializing()) {
    load();
  }

  final SettingsService set;
  final CabinetApi api;

  Future<void> load() async {
    state = FavoriteDatesState.initializing();
    try {
      DeviceRegisterAdd regData = set.getDeviceRegisterWithRegion();
      var localInfo = set.getLocalClientInfo();

      var res = await api.getFavoriteDates(regData, localInfo);
      if (res.result) {
        if (res.data!.isEmpty) {
          state = FavoriteDatesState.emptyData();
        } else {
          state = FavoriteDatesState.loaded(res.data!);
        }
      } else {
        state = FavoriteDatesState.error(AppRes.error);
      }
    } catch (e) {
      state = FavoriteDatesState.error(AppRes.error);
    }
  }

  Future<Exception?> addDate(AddFavoriteDateRequest request) async {
    try {
      DeviceRegisterAdd regData = set.getDeviceRegisterWithRegion();
      var localInfo = set.getLocalClientInfo();

      var res = await api.addFavoriteDate(request, regData, localInfo);
      if (!res.result) {
        return Exception(res.errors);
      }
    } catch (e) {
      return e as Exception;
    }

    return null;
  }

  Future<Exception?> editDate(
    int eventId,
    EditFavoriteDateRequest request,
  ) async {
    try {
      DeviceRegisterAdd regData = set.getDeviceRegisterWithRegion();
      var localInfo = set.getLocalClientInfo();

      var res =
          await api.editFavoriteDate(eventId, request, regData, localInfo);
      if (!res.result) {
        return Exception(res.errors);
      }
    } catch (e) {
      return e as Exception;
    }

    return null;
  }

  Future<Exception?> deleteDate(int eventId) async {
    try {
      DeviceRegisterAdd regData = set.getDeviceRegisterWithRegion();
      var localInfo = set.getLocalClientInfo();

      var res = await api.deleteFavoriteDate(eventId, regData, localInfo);
      if (!res.result) {
        return Exception(res.errors);
      }
    } catch (e) {
      return e as Exception;
    }

    return null;
  }
}

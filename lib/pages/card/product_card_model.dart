import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/product_card_api.dart';
import 'package:cvetovik/core/services/providers/linked_data_provider.dart';
import 'package:cvetovik/core/services/providers/region_info_provider.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/state/product_card_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productCardModelProvider = StateNotifierProvider.autoDispose
    .family<ProductCardModel, ProductCardState, int>((ref, id) {
  var set = ref.read(settingsProvider);
  var api = ref.read(productCardApiProvider);
  var info = ref.read(repositoryInfoProvider);
  var linked = ref.read(linkedDataProvider);
  return ProductCardModel(
      set: set, api: api, id: id, regionInfo: info, linked: linked, ref: ref);
});

class ProductCardModel extends StateNotifier<ProductCardState> {
  final AutoDisposeStateNotifierProviderRef ref;
  final int id;
  final SettingsService set;
  final ProductCardApi api;
  final RegionInfoRepository regionInfo;
  final LinkedDataProvider linked;
  ProductCardModel(
      {required this.id,
      required this.set,
      required this.api,
      required this.regionInfo,
      required this.linked,
      required this.ref})
      : super(const ProductCardState.initializing()) {
    load();
  }

  Future<void> load() async {
    var regData = set.getDeviceRegisterWithRegion();
    var clientInfo = set.getLocalClientInfo();

    var res = await api.getProductCard(
        deviceRegister: regData, id: id, clientInfo: clientInfo);
    if (res.result && res.data != null) {
      var linkedProducts =
          await linked.getLinkedProducts(res.data!.catalogId, regData);
      var comments = await api.getComments(
          deviceRegister: regData, id: id, clientInfo: clientInfo);
      var info = await regionInfo.getRegionInfo(regData);
      state = ProductCardState.loaded(res, info, linkedProducts, comments);
    } else {
      state = ProductCardState.error(AppRes.error);
    }
  }
}

import 'package:collection/collection.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/cabinet_api.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/services/providers/delivery_info_provider.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/request/promo_code_request.dart';
import 'package:cvetovik/models/api/response/cabinet/promo_code_response.dart';
import 'package:cvetovik/models/state/cart_content_state.dart';
import 'package:cvetovik/pages/cart/models/cart_data_with_discount.dart';
import 'package:cvetovik/pages/cart/models/cart_price_data.dart';
import 'package:cvetovik/pages/cart/models/promo_code_error_data.dart';
import 'package:cvetovik/pages/cart/models/row_provider_data.dart';
import 'package:cvetovik/pages/cart/provider/cart_row_base_model.dart';
import 'package:cvetovik/pages/ordering/models/discount/discount_data.dart';
import 'package:cvetovik/pages/ordering/models/discount/discount_item.dart';
import 'package:cvetovik/pages/ordering/ordering_page.dart';
import 'package:cvetovik/pages/ordering/providers/current_discount_provider.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartPriceProvider = StateNotifierProvider.family<CartPriceModel,
    CartContentState, List<CartMainData>>((ref, param) {
  return CartPriceModel(ref: ref, data: param);
});

class CartPriceModel extends StateNotifier<CartContentState> {
  final StateNotifierProviderRef ref;
  final List<CartMainData> data;
  CartPriceData _cartData = CartPriceData.init();
  CartPriceData get cartData => _cartData;
  List<DiscountItem> discountItems = [];

  CartPriceModel({
    required this.ref,
    required this.data,
  }) : super(CartContentState.initializing()) {
    init();
  }

  Future<int> _getAddSum() async {
    var cartDao = ref.read(cartDaoProvider);
    var add = await cartDao.getAddItems();
    int sum = 0;
    if (add != null) {
      add.forEach((element) {
        sum = sum + element.price;
      });
    }
    return sum;
  }

  late List<CartRowBaseModel> models;

  Future<void> init() async {
    var sumWithDiscount = 0;
    models =
        data.map((e) => CartRowBaseModel(RowProviderData(e, null))).toList();
    models.forEach((el) {
      sumWithDiscount = sumWithDiscount + el.getSum();
    });
    int rawRegular = 0;
    data.forEach((element) {
      rawRegular = rawRegular + (element.regularPrice * element.count);
    });
    var summa = rawRegular;
    int addSum = await _getAddSum();
    sumWithDiscount = sumWithDiscount + addSum;
    _cartData =
        _cartData.copyWith(summa: summa, sumWithDiscount: sumWithDiscount);
    state = CartContentState.loaded(_cartData);
  }

  Future<void> goCheckout(BuildContext context, String promoCode,int? useBonus) async {
    var deliveryInfoProv = ref.watch(deliveryInfoProvider.notifier);
    var set = ref.read(settingsProvider);
    var regData = set.getDeviceRegisterWithRegion();
    var deliveryInfo = await deliveryInfoProv.getDeliveryInfo();
    if (_cartData.promoCodeDiscount > 0) {
      var discountProv = ref.read(discountProvider.notifier);
      discountProv.state =
          DiscountData(items: discountItems, promoCode: promoCode);
    }
    // log("delivery info before pushing ${deliveryInfo.timeRanges. }");
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderingPage(useBonus: useBonus,
                deliveryInfo: deliveryInfo!,
                cartData: _cartData,
              )),
    );
  }

  Future<void> deleteAll() async {
    var cartDao = ref.read(cartDaoProvider);
    await cartDao.deleteAll();
  }

  Future<void> checkPromoCode(BuildContext context, String promoCode) async {
    if (promoCode.isNotEmpty) {
      var cabinetApi = ref.read(cabinetApiProvider);
      var set = ref.read(settingsProvider);
      var deviceRegister = set.getDeviceRegisterWithRegion();
      var clientInfo = set.getLocalClientInfo();
      var promoCodeData = PromoCodeRequest(promoCode: promoCode);
      var res = await cabinetApi.checkPromoCode(
          deviceRegister, promoCodeData, clientInfo);
      if (res.result && res.data != null) {
        //EnumToString
        var promoType =
            EnumToString.fromString(PromoCodeType.values, res.data!.type)!;
        switch (promoType) {
          case PromoCodeType.order:
            if (res.data!.discount != null && res.data!.minimumSum != null) {
              var discount = int.tryParse(res.data!.discount!);
              var minimumSum = int.tryParse(res.data!.minimumSum!);
              int price = 0;
              models.forEach((el) {
                price = price + el.getSum();
              });
              if (minimumSum != null &&
                  discount != null &&
                  minimumSum <= price) {
                _cartData = _cartData.copyWith(promoCodeDiscount: discount);
                state = CartContentState.checkedPromoCode(_cartData);
              } else {
                var mess =
                    '${AppRes.minimumSumForPromoCode} $minimumSum${AppRes.shortCurrency}';
                AppUi.showToast(context, mess);
              }
            }
            // TODO: Handle this case.
            break;
          case PromoCodeType.catalogs:
            if (res.data!.catalogsList != null &&
                res.data!.catalogsList!.isNotEmpty) {
              List<CartDataDiscount> tmpDiscountItems = [];
              data.forEach((el) {
                var curr = res.data!.catalogsList!.keys
                    .firstWhereOrNull((e) => e == el.catalogId.toString());
                if (curr != null) {
                  var value = res.data!.catalogsList![curr];
                  if (value != null) {
                    int? discount = int.tryParse(value);
                    tmpDiscountItems.add(CartDataDiscount(el, discount!));
                  }
                }
              });
              if (tmpDiscountItems.isNotEmpty) {
                FocusScope.of(context).unfocus();
                double allDiscount = 0;
                tmpDiscountItems.forEach((el) {
                  var curr = models
                      .firstWhereOrNull((e) => e.data.main.id == el.data.id);
                  if (curr != null) {
                    var currDiscount = (curr.price * el.discountPercent) / 100;
                    allDiscount = allDiscount + (currDiscount * el.data.count);
                    discountItems.add(DiscountItem(
                        productId: el.data.productId,
                        value: currDiscount.truncate()));
                  }
                });
                _cartData =
                    _cartData.copyWith(promoCodeDiscount: allDiscount.round());
                state = CartContentState.checkedPromoCode(_cartData);
              }
            }
            break;
          case PromoCodeType.products_rubles:
            // TODO: Handle this case.
            break;
          case PromoCodeType.products_percent:
            // TODO: Handle this case.
            break;
        }
      } else {
        _cartData = _cartData.copyWith(promoCodeDiscount: 0);
        late String error;
        if (res.errors == null) {
          error = AppRes.error;
        } else {
          if (res.errors!.isNotEmpty) {
            var rawError = res.errors!.first;
            error = PromoCodeErrorList.getLocaleByError(rawError);
          } else {
            error = AppRes.error;
          }
        }
        AppUi.showToast(context, error);
      }
    }
  }
}

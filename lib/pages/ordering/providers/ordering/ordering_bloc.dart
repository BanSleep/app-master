import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/services/providers/new_order_provider.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/main.dart';
import 'package:cvetovik/models/api/request/order_request.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/pages/cart/provider/product_cart_provider.dart';
import 'package:cvetovik/pages/ordering/mixin/address_mixin.dart';
import 'package:cvetovik/pages/ordering/models/delivery_param.dart';
import 'package:cvetovik/pages/ordering/models/enums/zones_delivery.dart';
import 'package:cvetovik/pages/ordering/models/map_position.dart';
import 'package:cvetovik/pages/ordering/models/order_result_data.dart';
import 'package:cvetovik/pages/ordering/models/payment_method_data.dart';
import 'package:cvetovik/pages/ordering/order_result_page.dart';
import 'package:cvetovik/pages/ordering/providers/current_discount_provider.dart';
import 'package:cvetovik/pages/ordering/providers/ordering/calc_delivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:tuple/tuple.dart';

import 'calc_delivery.dart';

typedef OnGetOrderData = OrderResultData Function();

final orderingBlocProvider = Provider<OrderingBloc>((ref) {
  return OrderingBloc(ref);
});

class OrderingBloc with AddressMixin {
  late DeliveryInfo deliveryInfo;
  late OnGetOrderData getOrderData;
  late bool isCourier;
  late BuildContext context;
  late CalcDelivery _calcDelivery;
  final ProviderRef ref;
  late bool checkMinSum;
  OrderResultData? _orderData;
  int _price = 0;
  int _orderId = 0;
  int _deliveryPrice = 0;

  OrderingBloc(this.ref);

  int get orderId => _orderId;

  void init(
      {required BuildContext context,
      required OnGetOrderData getOrderData,
      required bool isCourier,
      required DeliveryInfo deliveryInfo}) async {
    this.context = context;
    this.isCourier = isCourier;
    this.getOrderData = getOrderData;
    this.deliveryInfo = deliveryInfo;

    if (isProd) {
      checkMinSum = true;
    } else {
      checkMinSum = false;
    }
    _price = 0;
    _orderId = 0;
    _deliveryPrice = 0;
    _orderData = null;
    _calcDelivery = CalcDelivery(deliveryInfo);
  }

  void updateIsCourier(bool isCourier) {
    this.isCourier = isCourier;
  }

  int _calcFullPrice() {
    var discountProv = ref.read(discountProvider.notifier);
    int discount = 0;
    if (discountProv.state.items.isNotEmpty) {
      var items = discountProv.state.items.map((e) => e.value).toList();
      discount = items.reduce((a, b) => a + b);
    }
    var res = (_price - discount) + _deliveryPrice;
    return res;
  }

  List<TimeRangeData> getTimeRanges(DateTime dt, int? zoneIndex) {
    String dtf = DateFormat('dd.MM.yyyy').format(dt);
    print("dtf from getTimeRanges: $dtf");

    var range = deliveryInfo.timeRanges.timeRangesDefault.toList();

    // if (zoneIndex != null)
    //   range = range.where((e) => e.zone == zoneIndex).toList();

    log("delinfo ($dtf)");
    var tra = deliveryInfo.timeRanges.timeRangesAll;
    for (var k in tra.keys) {
      // log("tra[k].len: ${tra[k]!.length}");
      // if (zoneIndex != null) {
      //   tra[k]!.forEach((e) {
      //     print(e.zone);
      //   });
      //   tra[k] = tra[k]!.where((e) => (e.zone == zoneIndex)).toList();
      //   log("KEY k=$k zoneIndex=$zoneIndex ${zoneIndex.runtimeType} tra[k].len: ${tra[k]!.length}");
      // }
      // log("KEY $k -> ${tra[k]!.map((x) => x.toJson())}");
    }
    if (tra.containsKey(dtf)) {
      log("selecting time ranges for date $dtf");
      range = tra[dtf]!.toList();
    }

    log("resulting selected time range : ${range.map((x) => x.toJson())}");

    return range;
  }

  Future<Tuple2<List<TimeRangeData>, ZonesDelivery>> getTimeRangesByPoints(
      {required LatLng currPoint}) async {
    ZonesDelivery zone = await _calcDelivery.getZone(currPoint);
    if (zone == ZonesDelivery.none) {
      return Tuple2<List<TimeRangeData>, ZonesDelivery>([], zone);
    } else {
      var range = deliveryInfo.timeRanges.timeRangesDefault
          .where((element) => element.zone == zone.index)
          .toList();
      return Tuple2<List<TimeRangeData>, ZonesDelivery>(range, zone);
    }
  }

  Future<String?> checkPayment(
      PaymentMethodData? paymentData, int? useBonus) async {
    _orderData = getOrderData();

    if (_orderData == null) {
      AppUi.showToast(context, AppRes.error);
      return null;
    }
    if (_orderData != null && _orderData!.request != null) {
      if (paymentData != null) {
        _orderData!.request!.paymentMethod = paymentData.value;
      }
      if (useBonus != null && useBonus > 0) {
        _orderData!.request!.useBonus = useBonus;
      }
    }

    if (_orderData!.error.isNotEmpty) {
      AppUi.showToast(context, _orderData!.error);
      return null;
    }

    if (_orderData!.request == null || _orderData!.pos == null) {
      AppUi.showToast(context, _orderData!.error);
      return null;
    }
    if (paymentData == null) {
      AppUi.showToast(context, AppRes.selectPaymentType);
      return null;
    }

    var productCartProv = ref.read(productCartProvider);
    List<NewOrderProduct> products = [];
    var rawProducts = await productCartProv.getProductsForOrder();

    var discountProv = ref.read(discountProvider.notifier);
    var discountItems = discountProv.state.items;
    if (discountItems.isNotEmpty) {
      rawProducts.forEach((el) {
        var currDiscount =
            discountItems.firstWhereOrNull((e) => e.productId == el.productId);
        if (currDiscount != null) {
          var newOrderProduct = NewOrderProduct(
              productId: el.productId,
              number: el.number,
              options: el.options,
              versionId: el.versionId,
              price: el.price - (currDiscount.value * el.number));
          products.add(newOrderProduct);
        } else {
          rawProducts.add(el);
        }
      });
    } else {
      products = rawProducts;
    }
    _orderData!.request!.products = products;

    rawProducts.forEach((element) {
      _price = _price + (element.price * element.number);
      if (element.options != null) {
        element.options!.forEach((element) {
          _price = _price + element.price;
        });
      }
    });

    var currPoint =
        LatLng(_orderData!.pos!.latitude, _orderData!.pos!.longitude);
    ZonesDelivery zone = await _calcDelivery.getZone(currPoint);
    if (isCourier && zone == ZonesDelivery.none) {
      AppUi.showToast(context, AppRes.notDelivery);
      return null;
    }

    var check = false;
    var fullPrice = _calcFullPrice();
    if (isCourier) {
      check = _checkCourier(_orderData!.request!, fullPrice);
    } else {
      check = _checkGetSelf(_orderData!.request!, fullPrice);
    }
    if (isCourier) {
      /*bool extractTime = _orderData!.request!.exactTime != null
          ? _orderData!.request!.exactTime!
          : false;*/
      //TimeRangeData? data = _orderData!.data;
      if (_calcDelivery.distance == null && zone != ZonesDelivery.zone1) {
        AppUi.showToast(context, AppRes.distanceNotDefine);
        return null;
      }
      /*var param = DeliveryParam(
        extractTime: extractTime,
        price: _price,
        timeRange: data,
      );
      calcDeliveryPrice(zone, param);*/
      _orderData!.request!.deliveryPrice = _deliveryPrice;
    }
    if (!check) {
      return null;
    }

    var newOrderProv = ref.read(newOrderProvider);
    _orderId = await newOrderProv.createOrder(_orderData!.request!);
    if (_orderId > 0) {
      var cartDao = ref.read(cartDaoProvider);
      await cartDao.deleteAll();
      var addressDao = ref.read(addressDaoProvider);
      await addressDao.deleteTmpAddress();
      var paymentWidget = '123';
      //await newOrderProv.getPaymentWidget();
      return paymentWidget;
    } else {
      AppUi.showToastFromRes(context, false);
      return null;
    }
  }

  int calcDeliveryPrice(
      ZonesDelivery zone, bool extractTime, TimeRangeData? data) {
    var param = DeliveryParam(
      extractTime: extractTime,
      price: _price,
      timeRange: data,
    );
    var deliveryPriceRaw = _calcDelivery.calc(zone, param);
    log("delivery price raw $deliveryPriceRaw");
    _deliveryPrice = (deliveryPriceRaw != null) ? deliveryPriceRaw : 0;
    return _deliveryPrice;
  }

  Future<void> paymentCompleted(BuildContext context) async {
    var fullPrice = _calcFullPrice();
    print("Full price by ordering_bloc: $fullPrice");
    try {
      String? address;
      if (_orderData != null && _orderData!.request != null) {
        address = _orderData!.request!.deliveryAddress;
      }
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => OrderResultPage(
                  orderId: _orderId,
                  address: address,
                  price: fullPrice.toString(),
                )),
        ModalRoute.withName('/'),
      );
    } catch (e) {
      print(e);
    }
  }

  MapPosition? getCenterPosition() {
    if (deliveryInfo.mapCenter.isNotEmpty) {
      var res = getPositionFromStr(value: deliveryInfo.mapCenter);
      return res;
    }
    return null;
  }

  bool _checkCourier(OrderRequest req, int price) {
    if (checkMinSum) {
      if (price < deliveryInfo.deliveryMinSum) {
        var mess =
            '${AppRes.selfGetIsPossible} ${deliveryInfo.deliveryMinSum} ${AppRes.shortCurrency}';
        AppUi.showToast(context, mess);
        return false;
      }
    }
    if (req.name.isEmpty) {
      AppUi.showToast(context, AppRes.pleaseInputName);
      return false;
    }
    if (req.phone.isEmpty) {
      AppUi.showToast(context, AppRes.pleaseInputPhone);
      return false;
    }
    if (req.delivery != null && req.delivery! == true) {
      if (req.deliveryName == null || req.deliveryName!.isEmpty) {
        AppUi.showToast(context, AppRes.inputNameReceiver);
        return false;
      }
      if (req.deliveryPhone == null || req.deliveryPhone!.isEmpty) {
        AppUi.showToast(context, AppRes.inputPhoneReceiver);
        return false;
      }
    }
    return true;
  }

  bool _checkGetSelf(OrderRequest req, int price) {
    if (checkMinSum) {
      if (price < deliveryInfo.selfMinSum) {
        var mess =
            '${AppRes.pickupIsPossible} ${deliveryInfo.selfMinSum} ${AppRes.shortCurrency}';
        AppUi.showToast(context, mess);
        return false;
      }
    }
    if (req.name.isEmpty) {
      AppUi.showToast(context, AppRes.pleaseInputName);
      return false;
    }
    if (req.phone.isEmpty) {
      AppUi.showToast(context, AppRes.pleaseInputPhone);
      return false;
    }

    if (req.deliveryShop == null) {
      AppUi.showToast(context, AppRes.selectShop);
      return false;
    }
    return true;
  }
}

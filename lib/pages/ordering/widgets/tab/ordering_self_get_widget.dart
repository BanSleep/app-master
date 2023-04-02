import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/providers/region_shops_provider.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/request/order_request.dart';
import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:cvetovik/pages/ordering/mixin/address_mixin.dart';
import 'package:cvetovik/pages/ordering/mixin/payment_data_mixin.dart';
import 'package:cvetovik/pages/ordering/models/map_position.dart';
import 'package:cvetovik/pages/ordering/models/order_result_data.dart';
import 'package:cvetovik/pages/ordering/models/payment_method_data.dart';
import 'package:cvetovik/pages/ordering/providers/center_position_provider.dart';
import 'package:cvetovik/pages/ordering/shop_list_page.dart';
import 'package:cvetovik/pages/ordering/widgets/select/payment/select_payment_item_widget.dart';
import 'package:cvetovik/pages/ordering/widgets/select/payment/select_payment_method_sheet.dart';
import 'package:cvetovik/pages/ordering/widgets/shops_map_page.dart';
import 'package:cvetovik/pages/user/personal/personal_start_model.dart';
import 'package:cvetovik/widgets/check_box_widget.dart';
import 'package:cvetovik/widgets/date_picker_widget.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:cvetovik/widgets/time/time_interval_selfget_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class OrderingSelfGetWidget extends ConsumerStatefulWidget {
  final List<String> payments;
  final Function(PaymentMethodData? data) onSelectPayment;
  final PaymentMethodData? paymentInfo;
  const OrderingSelfGetWidget({
    required this.payments,
    required this.onSelectPayment,
    required this.paymentInfo,
    Key? key,
  }) : super(key: key);
  @override
  _OrderingSelfGetWidgetState createState() => _OrderingSelfGetWidgetState();
}

class _OrderingSelfGetWidgetState extends ConsumerState<OrderingSelfGetWidget>
    with GetOrderMixin, AddressMixin, PaymentMixinData {
  final keyName = GlobalKey();
  final keyPhone = GlobalKey();
  final keyNotCall = GlobalKey();
  final keyTime = GlobalKey();
  final keyDate = GlobalKey();

  late YandexMapController _controller;
  RegionShopInfo? _currShop;
  @override
  void initState() {

    super.initState();
  }

  @override
  OrderResultData value() {
    var name = (keyName.currentState! as GetStrMixin).value();
    var phone = (keyPhone.currentState! as GetStrMixin).value();
    var notCall = (keyNotCall.currentState! as SetBoolMixin).value();
    var date = (keyDate.currentState! as GetStrMixin).value();
    String? interval;
    if (keyTime.currentState != null) {
      interval = (keyTime.currentState! as GetStrMixin).value();
    }

    var req = OrderRequest(
        delivery: false,
        name: name,
        products: [],
        phone: phone,
        doNotCall: notCall,
        deliveryPhone: name,
        deliveryName: phone,
        deliveryDate: date,
        deliveryTimeRange: interval,
        deliveryShop: (_currShop != null) ? _currShop!.id : null);
    MapPosition? pos;
    if (_currShop != null) {
      var currPoint = getPositionFromStr(
        value: _currShop!.coordinates,
      );
      pos = MapPosition(
          longitude: currPoint!.longitude, latitude: currPoint.latitude);
    }

    return OrderResultData(
        request: req,
        error: (req.deliveryShop == null) ? AppRes.selectShop : '',
        pos: pos);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.read(personalStartModelProvider);
    final info = state.whenOrNull(loaded: (data, info) => info.data);

    var iconPayment = IconButton(
        highlightColor: Colors.transparent,
        color: AppAllColors.lightAccent,
        iconSize: 24.h,
        onPressed: () async {
          await _showPaymentMethodSheet(context);
        },
        icon: Icon(Icons.chevron_right));

    final double hStep = 16.h;
    var prov = ref.read(centerPositionProvider.state);
    var centerPos = prov.state;
    return GestureDetector(
      onTap: () {
        AppUi.hideKeyboard(context);
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
              ),
              child: SizedBox(
                height: 100.h,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 18.h,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await _selectAddressOnMethod(context, centerPos);
                    },
                    child: AbsorbPointer(
                      child: YandexMap(
                          mapObjects: mapObjects,
                          onMapCreated:
                              (YandexMapController yandexMapController) async {
                            _controller = yandexMapController;
                            if (centerPos != null) {
                              var fixPoint = Point(
                                  latitude: centerPos.latitude,
                                  longitude: centerPos.longitude);
                              await _controller.moveCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(target: fixPoint),
                                ),
                              );
                            }
                          }),
                    ),
                  ),
                ),
              ),
            ),
            if (_currShop != null)
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                child: Text(
                  (_currShop != null) ? _currShop!.address : '',
                  style: AppTextStyles.textField,
                ),
              )
            else
              SizedBox(
                height: 10.h,
              ),
            SizedBox(
              height: 44.h,
              width: double.infinity,
              child: ElevatedButton(
                style: AppUi.buttonActionStyle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Text(
                        AppRes.selectShopOnMap,
                        style: AppTextStyles.titleVerySmall
                            .copyWith(color: Colors.white, fontSize: 13.sp),
                      ),
                    ),
                    SvgPicture.asset(
                      AppIcons.map,
                      height: 18.h,
                      width: 18.h,
                    )
                  ],
                ),
                onPressed: () async {
                  await _selectAddressOnMethod(context, centerPos);
                },
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            SizedBox(
              height: 44.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var items = await _getShopList(context);
                  if (items != null)
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShopListPage(
                                items: items,
                              )),
                    ).then((value) async {
                      if (value != null && value is RegionShopInfo) {
                        await _selectShop(value);
                      }
                    });
                },
                style: AppUi.buttonActionWhiteStyle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Text(
                        AppRes.showShops,
                        style: AppTextStyles.titleVerySmall.copyWith(
                            color: AppAllColors.lightAccent, fontSize: 13.sp),
                      ),
                    ),
                    SvgPicture.asset(
                      AppIcons.shopList,
                      height: 18.h,
                      width: 18.h,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Text(
              AppRes.inputData,
              style: AppTextStyles.titleSmall
                  .copyWith(color: AppAllColors.lightBlack),
            ),
            SizedBox(
              height: hStep,
            ),
            AppTextField(
              key: keyName,
              hint: AppRes.hintName,
              title: AppRes.yourName,
              minLength: 4,
              errorText: AppRes.pleaseInputName,
              text: info == null ? null : info.firstname,
            ),
            SizedBox(
              height: hStep,
            ),
            AppTextField(
              key: keyPhone,
              hint: '+7',
              textFieldType: TextFieldType.phone,
              title: AppRes.yourPhone,
              minLength: 10,
              errorText: AppRes.pleaseInputPhone,
              text: info == null ? null : "+${info.phone}",
            ),
            SizedBox(
              height: hStep,
            ),
            CheckBoxWidget(
              key: keyNotCall,
              title: AppRes.notCall,
            ),
            SizedBox(
              height: hStep,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 147.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AppRes.dateDelivery,
                        style: AppTextStyles.textField
                            .copyWith(color: AppAllColors.lightBlack),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      DatePickerWidget(
                        key: keyDate,
                        timeRanges: [],
                        onUpdate: _onUpdateDate,
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: _currShop != null,
                    child: TimeIntervalSelfGetWidget(
                      key: keyTime,
                      timeRanges:
                          _currShop != null ? _currShop!.timeRanges : [],
                    )),
              ],
            ),
            SizedBox(
              height: hStep,
            ),
            Text(
              AppRes.selectPaymentMethod,
              style: AppTextStyles.titleSmall
                  .copyWith(color: AppAllColors.lightBlack),
            ),
            SizedBox(
              height: hStep,
            ),
            SelectPaymentItemWidget(
              data: widget.paymentInfo,
              onTap: (val) async {
                await _showPaymentMethodSheet(context);
              },
              icon: iconPayment,
            ),
            SizedBox(
              height: 35.h,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAddressOnMethod(
      BuildContext context, MapPosition? centerPos) async {
    var items = await _getShopList(context);
    if (items != null) {
      late MapPosition? position;
      if (_currShop != null) {
        position = getPositionFromStr(
          value: _currShop!.coordinates,
        );
      } else {
        position = centerPos;
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShopsMapPage(
                  items: items,
                  position: position,
                )),
      ).then((value) async {
        if (value != null && value is RegionShopInfo) {
          await _selectShop(value);
        }
      });
    }
  }

  final List<MapObject> mapObjects = [];
  Future<void> _selectShop(RegionShopInfo value) async {
    var currPoint = getPositionFromStr(
      value: value.coordinates,
    );
    if (currPoint != null) {
      var fixPoint =
          Point(longitude: currPoint.longitude, latitude: currPoint.latitude);

      mapObjects.add(PlacemarkMapObject(
          opacity: 1.0,
          icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(AppIcons.shopPoints),
            scale: AppUi.placeMarkScaleShop,
          )),
          point: fixPoint,
          mapId: MapObjectId(fixPoint.latitude.toString())));
      await _controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: fixPoint),
        ),
      );
    }
    setState(() {
      _currShop = value;
    });
  }

  Future<List<RegionShopInfo>?> _getShopList(BuildContext context) async {
    var shopsProv = ref.read(shopsProvider);
    var set = ref.read(settingsProvider);
    var deviceRegister = set.getDeviceRegisterWithRegion();
    List<RegionShopInfo>? items =
        await shopsProv.getRegionShops(deviceRegister);
    return items;
  }

  Future<void> _showPaymentMethodSheet(BuildContext context) async {
    await AppUi.showAppBottomSheet(
            context: context, child: SelectPaymentMethodSheet(payments: widget.payments,), isShape: true)
        .then((val) {
      if (val != null && val is PaymentMethodData) {
        setState(() {
          widget.onSelectPayment(val);
        });
      }
    });
  }

  _onUpdateDate(DateTime dt) {
    if (keyTime.currentState is SetTimeRangeSelfGetMixin) {
      (keyTime.currentState as SetTimeRangeSelfGetMixin)
          .initTimeRangeValueWithDt(dt);
    }
  }
}

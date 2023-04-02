import 'dart:developer';

import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/yandex_geocoder_api.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/request/order_request.dart';
import 'package:cvetovik/models/api/response/cabinet/favorite_address_list_response.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/pages/ordering/mixin/payment_data_mixin.dart';
import 'package:cvetovik/pages/ordering/models/enums/zones_delivery.dart';
import 'package:cvetovik/pages/ordering/models/map_position.dart';
import 'package:cvetovik/pages/ordering/models/order_result_data.dart';
import 'package:cvetovik/pages/ordering/models/payment_method_data.dart';
import 'package:cvetovik/pages/ordering/providers/ordering/current_zone_provider.dart';
import 'package:cvetovik/pages/ordering/providers/ordering/ordering_bloc.dart';
import 'package:cvetovik/pages/ordering/widgets/select/payment/select_payment_item_widget.dart';
import 'package:cvetovik/pages/ordering/widgets/select/payment/select_payment_method_sheet.dart';
import 'package:cvetovik/pages/profile/favorite_addresses/favorite_addresses_model.dart';
import 'package:cvetovik/pages/profile/favorite_addresses/favorite_addresses_selector_widget.dart';
import 'package:cvetovik/pages/template_page.dart';
import 'package:cvetovik/pages/user/personal/personal_start_model.dart';
import 'package:cvetovik/widgets/check_box_widget.dart';
import 'package:cvetovik/widgets/date_picker_widget.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:cvetovik/widgets/time/time_select_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:tuple/tuple.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class OrderingCourierWidget extends ConsumerStatefulWidget {
  OrderingCourierWidget({
    Key? key,
    required this.timeRanges,
    required this.deliveryInfo,
    required this.payments,
    required this.onSelectPayment,
    required this.paymentData,
  }) : super(key: key);
  List<String> payments;
  List<TimeRangeData> timeRanges;
  final DeliveryInfo deliveryInfo;
  final PaymentMethodData? paymentData;
  final Function(PaymentMethodData data) onSelectPayment;

  @override
  _OrderingCourierWidgetState createState() => _OrderingCourierWidgetState();
}

class _OrderingCourierWidgetState extends ConsumerState<OrderingCourierWidget>
    with AutomaticKeepAliveClientMixin, GetOrderMixin, PaymentMixinData {
  final keyName = GlobalKey();
  final keyPhone = GlobalKey();
  final keyComment = GlobalKey();
  final keyPostcard = GlobalKey();
  final keyPhoneReceiver = GlobalKey();
  final keyNameReceiver = GlobalKey();
  final keySelfGetOrder = GlobalKey();
  final keyNotCall = GlobalKey();
  final keyDate = GlobalKey();
  final keyTime = GlobalKey();
  bool _showRecipient = true;

  List<TimeRangeData> timeRanges = [];
  late Point currPos;

  FavoriteAddressWithPosition? selectedFavoriteAddress;

  @override
  void initState() {
    super.initState();
    currPos = Point(latitude: 0, longitude: 0);
  }

  @override
  Widget build(BuildContext context) {
    final double hStep = 16.h;
    super.build(context);
    var iconPayment = IconButton(
        highlightColor: Colors.transparent,
        color: AppAllColors.lightAccent,
        iconSize: 24.h,
        onPressed: () async {
          await _showPaymentMethodSheet(context,widget.payments);
        },
        icon: Icon(Icons.chevron_right));

    final state = ref.watch(personalStartModelProvider);

    return state.when(
      initializing: () => TemplatePage(body: LoadingWidget()),
      loaded: (data, info) {
        return GestureDetector(
          onTap: () {
            AppUi.hideKeyboard(context);
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 35.h, bottom: hStep),
                  child: Text(
                    AppRes.inputData,
                    style: AppTextStyles.titleSmall
                        .copyWith(color: AppAllColors.lightBlack),
                  ),
                ),
                AppTextField(
                  key: keyName,
                  hint: AppRes.hintName,
                  title: AppRes.yourName,
                  minLength: 3,
                  errorText: AppRes.pleaseInputName,
                  text: info.data?.firstname,
                ),
                SizedBox(
                  height: hStep,
                ),
                AppTextField(
                  key: keyPhone,
                  textFieldType: TextFieldType.phone,
                  title: AppRes.yourPhone,
                  minLength: 10,
                  errorText: AppRes.pleaseInputPhone,
                  text: info.data == null ? null : "+${info.data!.phone}",
                ),
                SizedBox(
                  height: hStep,
                ),
                CheckBoxWidget(
                  key: keySelfGetOrder,
                  title: AppRes.selfGetOrder,
                  onChanged: _onChangedGetSelf,
                ),
                Visibility(
                    visible: _showRecipient,
                    child: Column(
                      children: [
                        SizedBox(
                          height: hStep,
                        ),
                        AppTextField(
                          key: keyNameReceiver,
                          title: AppRes.nameReceiver,
                          minLength: 3,
                          errorText: AppRes.pleaseInputName,
                        ),
                        SizedBox(
                          height: hStep,
                        ),
                        AppTextField(
                          key: keyPhoneReceiver,
                          hint: '+7',
                          textFieldType: TextFieldType.phone,
                          title: AppRes.phoneReceiver,
                          minLength: 10,
                          errorText: AppRes.pleaseInputPhone,
                        ),
                      ],
                    )),
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
                SizedBox(
                  height: hStep,
                ),
                FavoriteAddressesSelectorWidget(
                  selectedFavoriteAddress: selectedFavoriteAddress,
                  onSelected: (data) async {
                    if (data == null) {
                      data =
                          ref.read(favoriteAddressesModelProvider).whenOrNull(
                                loaded: (data) => data.first,
                              );

                      if (data == null) {
                        setState(() => selectedFavoriteAddress = null);
                        return;
                      }
                    }

                    var point = await ref
                        .read(yandexGeocoderApiProvider)
                        .getPointFromAddress(
                            "${data.address} ${data.addressAdditional}");

                    if (point != null) {
                      setState(() => selectedFavoriteAddress =
                          FavoriteAddressWithPosition.fromFavoriteAddress(
                              data!, point));

                      _onUpdatePos();
                    }
                  },
                ),
                SizedBox(
                  height: hStep,
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
                            timeRanges: timeRanges,
                            onUpdate: _onUpdateDate,
                          ),
                        ],
                      ),
                    ),
                    TimeSelectWidget(
                      key: keyTime,
                      timeRanges: timeRanges,
                      onUpdatedRange: _onUpdatedRange,
                      onUpdatedExactTime: _onUpdatedExactTime,
                      onUpdatedZone: (newZone) =>
                          setState(() => zone = newZone),
                      blocRef: ref,
                      zone: zone,
                    ),
                  ],
                ),
                SizedBox(
                  height: hStep,
                ),
                AppTextField(
                  key: keyPostcard,
                  textFieldType: TextFieldType.normal,
                  title: AppRes.textCard,
                  maxLines: 8,
                ),
                SizedBox(
                  height: hStep,
                ),
                AppTextField(
                  key: keyComment,
                  textFieldType: TextFieldType.normal,
                  title: AppRes.comment,
                  maxLines: 4,
                ),
                SizedBox(
                  height: 35.h,
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
                  data: widget.paymentData,
                  onTap: (val) async {
                    await _showPaymentMethodSheet(context,widget.payments);
                  },
                  icon: iconPayment,
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        );
      },
      error: (String? text) {
        return _getError(text, ref);
      },
    );
  }

  Future<void> _showPaymentMethodSheet(BuildContext context,List<String> payments) async {
    await AppUi.showAppBottomSheet(
            context: context, child: SelectPaymentMethodSheet(payments: payments,), isShape: true)
        .then((val) {
      if (val != null && val is PaymentMethodData) {
        setState(() {
        widget.onSelectPayment(val);
        });
      }
    });
  }

  @override
  OrderResultData value() {
    String? nameR;
    String? phoneR;
    var nameSelf = (keyName.currentState! as GetStrMixin).value();
    var phoneSelf = (keyPhone.currentState! as GetStrMixin).value();
    var selfGet = (keySelfGetOrder.currentState! as SetBoolMixin).value();
    if (selfGet) {
      nameR = nameSelf;
      phoneR = phoneSelf;
    } else {
      nameR = (keyNameReceiver.currentState! as GetStrMixin).value();
      phoneR = (keyPhoneReceiver.currentState! as GetStrMixin).value();
    }
    var notCall = (keyNotCall.currentState! as SetBoolMixin).value();
    var date = (keyDate.currentState! as GetStrMixin).value();
    var time = (keyTime.currentState! as GetTimeMixin).value();
    var textPostcard = (keyPostcard.currentState! as GetStrMixin).value();
    var comment = (keyComment.currentState! as GetStrMixin).value();

    if (selectedFavoriteAddress == null) {
      return OrderResultData(error: AppRes.selectAddress2);
    }

    var req = OrderRequest(
      delivery: true,
      name: nameSelf,
      phone: phoneSelf,
      products: [],
      deliveryName: nameR,
      deliveryPhone: phoneR,
      comment: comment,
      deliveryAddress: selectedFavoriteAddress!.address,
      deliveryAddressAdditional: selectedFavoriteAddress!.addressAdditional,
      deliveryDate: date,
      doNotCall: notCall,
      exactTime: time.extractTime,
      postcardText: textPostcard,
    );

    if (time.extractTime) {
      req.deliveryExactTime = time.value;
    } else {
      var value = time.value.replaceAll(':00', '');
      print("delivery time range ${value}|");
      req.deliveryTimeRange = value;
    }

    return OrderResultData(
      request: req,
      data: time.data,
      pos: MapPosition(
        longitude: selectedFavoriteAddress!.long,
        latitude: selectedFavoriteAddress!.lat,
      ),
    );
  }

  _onUpdateDate(DateTime dt) {
    if (keyTime.currentState is SetTimeRangeSelfGetMixin) {
      (keyTime.currentState as SetTimeRangeSelfGetMixin)
          .initTimeRangeValueWithDt(dt);
    }

    // var tr = ref.read(orderingBlocProvider).getTimeRanges(dt);
    // widget.timeRanges = tr;
    // print("tr: ${tr.map((x) => x.toJson())}");

    // (keyTime.currentState! as TimeRangeUpdateMixin).initTimeRanges();
    // (keyTime.currentState! as TimeRangeUpdateMixin).initTimeRangeValue(
    //     Tuple2<List<TimeRangeData>, ZonesDelivery>
    // );
  }

  @override
  bool get wantKeepAlive => true;

  void _onChangedGetSelf(bool value) {
    setState(() {
      _showRecipient = !value;
    });
  }

  ZonesDelivery zone = ZonesDelivery.zone1;

  int firstUpdate = 0;

  _onUpdatePos() async {
    log("on update pos");
    if (firstUpdate <= 1) {
      _onUpdateDate(DateTime.now());
      firstUpdate++;
    }
    if (currPos.longitude != selectedFavoriteAddress!.long &&
        currPos.latitude != selectedFavoriteAddress!.lat) {
      var bloc = ref.read(orderingBlocProvider);
      var time = (keyTime.currentState! as GetTimeMixin).value();
      var latLng =
          LatLng(selectedFavoriteAddress!.lat, selectedFavoriteAddress!.long);
      var res = await bloc.getTimeRangesByPoints(currPoint: latLng);
      zone = res.item2;
      timeRanges = widget.timeRanges
          .where((element) => element.zone == zone.index)
          .toList();
      (keyTime.currentState! as SetTimeRangeZoneMixin).initTimeRangeValue(
          Tuple2<List<TimeRangeData>, ZonesDelivery>(timeRanges, zone));
      var currZoneProvider = ref.read(currentDeliveryPriceProvider.notifier);

      int deliveryPrice = 0;
      if (timeRanges.isNotEmpty) {
        deliveryPrice =
            bloc.calcDeliveryPrice(zone, time.extractTime, timeRanges.first);
      }
      currZoneProvider.state = deliveryPrice;
      currPos = Point(
        latitude: selectedFavoriteAddress!.lat,
        longitude: selectedFavoriteAddress!.long,
      );
    }
  }

  _onUpdatedRange(TimeRangeData data) {
    var bloc = ref.read(orderingBlocProvider);
    var time = (keyTime.currentState! as GetTimeMixin).value();
    var currZoneProvider = ref.read(currentDeliveryPriceProvider.notifier);
    print("extract time : ${time.extractTime}");
    int deliveryPrice = bloc.calcDeliveryPrice(zone, time.extractTime, data);
    currZoneProvider.state = deliveryPrice;
  }

  _onUpdatedExactTime(bool isExact) {
    print("On updated exact time bool selected");
    var bloc = ref.read(orderingBlocProvider);
    var currZoneProvider = ref.read(currentDeliveryPriceProvider.notifier);
    int deliveryPrice = bloc.calcDeliveryPrice(zone, isExact, null);
    currZoneProvider.state = deliveryPrice;
    print("H2: ${currZoneProvider.state}");
  }

  Widget _getError(String? text, WidgetRef ref) {
    return TemplatePage(
      body: AppErrorWidget(
        text: text,
        tryAgain: () async {
          await ref.read(personalStartModelProvider.notifier).init();
        },
      ),
    );
  }
}

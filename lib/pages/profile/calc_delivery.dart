import 'dart:developer';

import 'dart:convert';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/services/providers/delivery_info_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/pages/ordering/mixin/address_mixin.dart';
import 'package:cvetovik/pages/ordering/models/address_full_data.dart';
import 'package:cvetovik/pages/ordering/models/delivery_param.dart';
import 'package:cvetovik/pages/ordering/models/enums/zones_delivery.dart';
import 'package:cvetovik/pages/ordering/models/map_position.dart';
import 'package:cvetovik/pages/ordering/providers/center_position_provider.dart';
import 'package:cvetovik/pages/ordering/providers/ordering/calc_delivery.dart';
import 'package:cvetovik/pages/ordering/widgets/address/address_suggestion_widget.dart';
import 'package:cvetovik/pages/profile/remove_account/more_about_delivery.dart';
import 'package:cvetovik/widgets/app_button.dart';
import 'package:cvetovik/widgets/date_picker_widget.dart';
import 'package:cvetovik/widgets/scaffold.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:cvetovik/widgets/state/not_data_widget.dart';
import 'package:cvetovik/widgets/time/time_interval_courier_widget.dart';
import 'package:cvetovik/widgets/time/time_select_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../core/api/yandex_geocoder_api.dart';

class DeliveryCalculationScreen extends ConsumerStatefulWidget {
  const DeliveryCalculationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DeliveryCalculationScreenState createState() =>
      _DeliveryCalculationScreenState();
}

class _DeliveryCalculationScreenState
    extends ConsumerState<DeliveryCalculationScreen> with AddressMixin {
  Future<bool> get locationPermissionGranted async =>
      await Permission.locationWhenInUse.request().isGranted;
  late YandexMapController _controller;
  final List<MapObject> mapObjects = [];
  late CalcDelivery calcDelivery;
  late DeliveryInfo deliveryInfo;
  final priceKey = GlobalKey();
  final addressKey = GlobalKey();
  final TextEditingController orderPrice = TextEditingController(text: '1000');

  bool _isLoading = false;
  DateTime deliveryDateTime = DateTime.now();
  String address = '';
  ZonesDelivery zonesDelivery = ZonesDelivery.none;
  List<TimeRangeData> ranges = [];
  LatLng currPoint = LatLng(0, 0);
  List<String> items = [];
  String selectedValue = '';
  double currentHour = double.parse(
      DateTime.now().hour.toString() + '.' + DateTime.now().minute.toString());
  // List<List<TimeRangeData>> listOfRanges = [];

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AppScaffold(
        resizeToAvoidBottomInset: false,
        title: Text('Доставка'),
        extendBodyBehindAppBar: true,
        body: Consumer(builder: (context, WidgetRef ref, Widget? child) {
          Widget? body;
          final stateDeliveryInfo = ref.watch(deliveryInfoProvider);
          stateDeliveryInfo.maybeWhen(
              orElse: () {
                body = Container();
              },
              initializing: () {
                body = LoadingWidget();
              },
              emptyData: () => NotDataWidget(),
              loaded: (data) {
                deliveryInfo = data;
                ranges = deliveryInfo.timeRanges.timeRangesDefault;
                if (items.isEmpty) {
                  for (int i = 0; i < ranges.length; i++) {
                    if (ranges[i].zone == 1) {
                      items.add('${ranges[i].startHour}:00 - ${ranges[i]
                          .stopHour}:00');
                    }
                  }
                  items = items.toSet().toList();
                  // items.sort();
                }
                if (selectedValue.isEmpty) {
                  selectedValue = items[0];
                }
                calcDelivery = CalcDelivery(deliveryInfo);
                body = LoadingOverlay(
                  isLoading: _isLoading,
                  opacity: AppUi.opacity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: YandexMap(
                          mapObjects: mapObjects,
                          onMapCreated: (yandexMapController) async {
                            _controller = yandexMapController;

                            // Point? fixPoint;
                            // var prov =
                            //     ref.read(centerPositionProvider.notifier);
                            List<double> mapCenter = [];
                            mapCenter.add(double.parse(
                                deliveryInfo.mapCenter.split(',').first));
                            mapCenter.add(double.parse(
                                deliveryInfo.mapCenter.split(',').last));
                            await _controller.moveCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: Point(
                                        longitude: mapCenter[1],
                                        latitude: mapCenter[0] - 0.4),
                                    zoom: 8)));
                          },
                          onMapTap: _onMapTap,
                        ),
                      ),
                      Positioned(
                        left: 10.w,
                        right: 10.w,
                        bottom: 22.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (!(await locationPermissionGranted)) {
                                  AppUi.showToast(
                                      context, "Не выдано разрешение");
                                  return;
                                }

                                setState(() => _isLoading = true);

                                final _userPosition =
                                    await _controller.getUserCameraPosition();

                                setState(() => _isLoading = false);

                                if (_userPosition != null) {
                                  await _controller.moveCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: _userPosition.target,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.map,
                                  color: AppAllColors.lightAccent,
                                  width: 22.r,
                                  height: 22.r,
                                ),
                              ),
                            ),
                            10.h.heightBox,
                            Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView(
                                padding: EdgeInsets.all(20),
                                shrinkWrap: true,
                                children: [
                                  AppTextField(
                                    key: priceKey,
                                    title: "Стоимость заказа",
                                    minLength: 1,
                                    text: orderPrice.text,
                                    controller: orderPrice,
                                  ),
                                  12.h.heightBox,
                                  AddressSuggestionWidget(
                                    key: addressKey,
                                    address: 'Санкт-Петербург',
                                    onSelected: (data) async {
                                      final point = Point(
                                        latitude: data.pos.latitude,
                                        longitude: data.pos.longitude,
                                      );

                                      await _controller.moveCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(target: point),
                                        ),
                                      );
                                      _onMapTap(point);

                                      await _appUserPoint(point);
                                    },
                                  ),
                                  12.h.heightBox,
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0.h),
                                            child: Text(
                                              'Дата доставки',
                                              textAlign: TextAlign.start,
                                              style: AppTextStyles.textField,
                                            ),
                                          ),
                                          DatePickerWidget(
                                            onUpdate: (dt) {
                                              deliveryDateTime =
                                                  deliveryDateTime.copyWith(
                                                year: dt.year,
                                                month: dt.month,
                                                day: dt.day,

                                              );
                                            },
                                            isRowPickers: true,
                                          ),
                                        ],
                                      ),
                                      18.w.widthBox,
                                      Column(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0.h),
                                            child: Text(
                                              'Время доставки',
                                              textAlign: TextAlign.start,
                                              style: AppTextStyles.textField,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 38.h,
                                            width: 128.w,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6.r),
                                                border: Border.all(
                                                  color: AppAllColors.lightGrey,
                                                  width: 1,
                                                ),
                                                color: AppAllColors.lightGrey,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 12),
                                                child: DropdownButton<String>(
                                                  value: selectedValue,
                                                  //elevation: 16,
                                                  icon: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(right: 10.w),
                                                        child: SvgPicture.asset(
                                                          AppIcons.time,
                                                          height: 18.h,
                                                          width: 18.w,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  isDense: false,
                                                  isExpanded: true,
                                                  style: AppTextStyles.textDateTime,
                                                  underline: Container(
                                                    height: 0,
                                                    color: Colors.deepPurpleAccent,
                                                  ),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedValue = newValue.toString();
                                                      currentHour = double.parse(
                                                                  selectedValue.split(':').first);
                                                              _onMapTap(Point(latitude: currPoint.latitude, longitude: currPoint.longitude));
                                                    });
                                                  },
                                                  items: items.map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: AppTextStyles.textDateTime,
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  12.h.heightBox,
                                  Row(
                                    children: [
                                      Text(
                                        'Стоимость доставки составит',
                                        style: AppTextStyles.textMediumBold,
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${zonesDelivery == ZonesDelivery.none || getTimeRangeData(
                                              zonesDelivery,
                                            ) == null ? 0 : calcDelivery.calcDelivery(
                                              zonesDelivery,
                                              DeliveryParam(
                                                price: double.parse(
                                                        orderPrice.text)
                                                    .toInt(),
                                                extractTime: false,
                                                timeRange: getTimeRangeData(
                                                  zonesDelivery,
                                                ),
                                              ),
                                          currPoint,
                                          deliveryInfo,
                                          currentHour,
                                            ) ?? 0} ₽',
                                        style: AppTextStyles.textMediumBold
                                            .copyWith(color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                  12.h.heightBox,
                                  AppButton(
                                    tap: () {
                                      AppUi.showAppBottomSheet(
                                        child: FractionallySizedBox(
                                          heightFactor: 0.95,
                                          child: MoreAboutDelivery(
                                            deliveryInfo: deliveryInfo,
                                          ),
                                        ),
                                        context: context,
                                      );
                                    },
                                    title: 'Узнать подробнее о доставке',
                                    withGreenBorder: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
          return body ?? Container();
        }),
      ),
    );
  }

  PlacemarkMapObject? _userPlaceMark;

  Future<void> _appUserPoint(Point point) async {
    zonesDelivery = await calcDelivery.getZone(
      LatLng(point.latitude, point.longitude),
    );
    if (zonesDelivery == ZonesDelivery.zone2 && (currentHour >= 21 || currentHour <= 9)) {
      zonesDelivery = ZonesDelivery.zone3;
    }
    setState(() {
      if (_userPlaceMark != null) {
        mapObjects.remove(_userPlaceMark!);
      }
      _userPlaceMark = PlacemarkMapObject(
          opacity: 1.0,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(AppIcons.userPoint),
              scale: AppUi.placeMarkScale,
            ),
          ),
          point: point,
          mapId: MapObjectId(point.latitude.toString()));
      mapObjects.add(_userPlaceMark!);
    });
  }

  void _onMapTap(Point point) async {
    setState(() {
      currPoint = LatLng(point.latitude, point.longitude);
    });
    calcDelivery.distanceFromZone1(
      LatLng(point.latitude, point.longitude),
    );
    try {
      setState(() {
        _isLoading = true;
      });
      var pStr = '${point.longitude},${point.latitude}';

      var address =
          await ref.read(yandexGeocoderApiProvider).getAddressFromPoint(pStr);

      await _appUserPoint(point);

      if (addressKey.currentState is SetAddressMixin && address != null) {
        var data = AddressFullData(
          MapPosition(latitude: point.latitude, longitude: point.longitude),
          address,
          "",
        );
        (addressKey.currentState as SetAddressMixin).initAddressValue(data);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  TimeRangeData? getTimeRangeData(ZonesDelivery zoneDelivery) {
    int zone = zoneDelivery == ZonesDelivery.zone1
        ? 1
        : zoneDelivery == ZonesDelivery.zone2
            ? 2
            : 3;
    List<TimeRangeData> tmd = deliveryInfo.timeRanges.timeRangesDefault
        .where(
          (element) =>
              element.zone == zone &&
              currentHour > element.startHour.toDouble() &&
              currentHour <= element.stopHour.toDouble(),
        )
        .toList();
    if (tmd.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Выбранное время доставки недоступно')),
        );
      });
      return null;
    } else {
      return deliveryInfo.timeRanges.timeRangesDefault
          .where(
            (element) =>
                element.zone == zone &&
                currentHour > element.startHour.toDouble() &&
                currentHour <= element.stopHour.toDouble(),
          )
          .toList()
          .first;
    }
  }
}

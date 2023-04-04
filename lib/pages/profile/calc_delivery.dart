import 'dart:developer';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cvetovik/const/app_icons.dart';
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
import 'package:cvetovik/pages/profile/remove_account/more_about_delivery.dart';
import 'package:cvetovik/widgets/app_button.dart';
import 'package:cvetovik/widgets/date_picker_widget.dart';
import 'package:cvetovik/widgets/scaffold.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../core/api/yandex_geocoder_api.dart';

class DeliveryCalculationScreen extends ConsumerStatefulWidget {
  final String address;
  final DeliveryInfo deliveryInfo;

  const DeliveryCalculationScreen({
    Key? key,
    required this.address,
    required this.deliveryInfo,
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
  late final CalcDelivery calcDelivery;

  final priceKey = GlobalKey();
  final addressKey = GlobalKey();

  bool _isLoading = false;
  DateTime deliveryDateTime = DateTime.now();
  String address = '';
  int orderPrice = 0;

  @override
  void initState() {
    calcDelivery = CalcDelivery(widget.deliveryInfo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (address.isNotEmpty) {
      setState(() {});
    }

    ///сука
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AppScaffold(
        resizeToAvoidBottomInset: true,
        title: Text('Доставка'),
        extendBodyBehindAppBar: true,
        body: Builder(builder: (context) {
          return LoadingOverlay(
            isLoading: _isLoading,
            opacity: AppUi.opacity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: YandexMap(
                    mapObjects: mapObjects,
                    onMapCreated: (yandexMapController) async {
                      _controller = yandexMapController;

                      Point? fixPoint;
                      var prov = ref.read(centerPositionProvider.notifier);
                      if (prov.state != null) {
                        fixPoint = Point(
                            latitude: prov.state!.latitude,
                            longitude: prov.state!.longitude);
                      }
                      if (fixPoint != null) {
                        await _controller.moveCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: fixPoint),
                          ),
                        );
                      }
                    },
                    onMapTap: _onMapTap,
                  ),
                ),
                Positioned(
                  left: 10.w,
                  right: 10.w,
                  bottom: 77.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (!(await locationPermissionGranted)) {
                            AppUi.showToast(context, "Не выдано разрешение");
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
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
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
                              text: orderPrice.toString(),
                              isVisibleText: false,
                            ),
                            12.h.heightBox,
                            AppTextField(
                              key: addressKey,
                              title: "Адрес",
                              minLength: 1,
                              text: address,
                              readOnly: true,
                              isVisibleText: false,
                            ),
                            12.h.heightBox,
                            Row(
                              children: [
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
                                18.w.widthBox,
                                DatePickerWidget(
                                  onUpdate: (dt) {
                                    deliveryDateTime =
                                        deliveryDateTime.copyWith(
                                      hour: dt.hour,
                                      minute: dt.minute,
                                    );
                                  },
                                  isTimePicker: true,
                                  isRowPickers: true,
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
                                  '${calcDelivery.calc(
                                    ZonesDelivery.zone1,
                                    DeliveryParam(
                                      price: orderPrice,
                                      extractTime: false,
                                      timeRange:
                                          getTimeRangeData(ZonesDelivery.zone1),
                                    ),
                                  )}₽',
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
                                      deliveryInfo: widget.deliveryInfo,
                                    ),
                                  ),
                                  context: context,
                                );
                              },
                              title: 'Узнать подробнее о доставке',
                              withGreenBorder: true,
                            ),
                            // AddressSuggestionWidget(
                            //   key: keyAddress,
                            //   address: widget.editingFavoriteAddress?.address,
                            //   onSelected: (data) async {
                            //     final point = Point(
                            //       latitude: data.pos.latitude,
                            //       longitude: data.pos.longitude,
                            //     );
                            //
                            //     await _controller.moveCamera(
                            //       CameraUpdate.newCameraPosition(
                            //         CameraPosition(target: point),
                            //       ),
                            //     );
                            //
                            //     await _appUserPoint(point);
                            //   },
                            // ),
                            // if ((widget.returnResult &&
                            //         widget.editingFavoriteAddress == null) &&
                            //     !widget.onlyNotSave) ...[
                            //   20.h.heightBox,
                            //   CheckBoxWidget(
                            //     selected: isSaving,
                            //     title: AppRes.saveAddress,
                            //     onChanged: (value) => setState(() {
                            //       isSaving = value;
                            //     }),
                            //   ),
                            //   10.h.heightBox,
                            // ],
                            // 10.h.heightBox,
                            // if (isSaving) ...[
                            //   AppTextField(
                            //     key: keyName,
                            //     hint: "Например, Марина Иванова",
                            //     title: "Имя",
                            //     minLength: 1,
                            //     errorText: "Введите имя",
                            //     text: widget.editingFavoriteAddress?.name,
                            //   ),
                            //   10.h.heightBox,
                            //   AppTextField(
                            //     key: keyTitle,
                            //     hint: "Например, Жена",
                            //     title: "Краткое описание",
                            //     minLength: 2,
                            //     errorText: "Введите краткое описание",
                            //     text: widget.editingFavoriteAddress?.title,
                            //   ),
                            //   10.h.heightBox,
                            //   AppTextField(
                            //     key: keyPhone,
                            //     hint: '+7',
                            //     textFieldType: TextFieldType.phone,
                            //     minLength: 10,
                            //     errorText: AppRes.pleaseInputPhone,
                            //     title: "Телефон",
                            //     text: widget.editingFavoriteAddress?.phone,
                            //   ),
                            // ],
                            // 20.h.heightBox,
                            // AppButton(
                            //   leftPad: 0,
                            //   rightPad: 0,
                            //   title: "Сохранить",
                            //   white: false,
                            //   tap: () async {
                            //     final address =
                            //         (keyAddress.currentState! as GetAddressMixin)
                            //             .value();
                            //
                            //     late String name, title, phone;
                            //
                            //     try {
                            //       name = (keyName.currentState! as GetStrMixin)
                            //           .value();
                            //       title = (keyTitle.currentState! as GetStrMixin)
                            //           .value();
                            //       phone = (keyPhone.currentState! as GetStrMixin)
                            //           .value();
                            //     } catch (_) {}
                            //
                            //     if (!isSaving) {
                            //       if (address == null || address.address.isEmpty)
                            //         return;
                            //     } else {
                            //       if (address == null ||
                            //           address.address.isEmpty ||
                            //           name.isEmpty ||
                            //           title.isEmpty ||
                            //           phone.isEmpty) return;
                            //     }
                            //
                            //     Exception? response;
                            //
                            //     if ((widget.returnResult && !isSaving) ||
                            //         (widget.returnResult &&
                            //             widget.editingFavoriteAddress != null)) {
                            //       return Navigator.of(context).pop(
                            //         FavoriteAddress(
                            //           id: -1,
                            //           regionId: 1,
                            //           address: address.address,
                            //           addressAdditional: address.addressAdditional,
                            //           name: "Несохраненный адрес",
                            //           title: address.address,
                            //           phone: "",
                            //         ),
                            //       );
                            //     }
                            //
                            //     if (widget.editingFavoriteAddress == null) {
                            //       response = await ref
                            //           .read(favoriteAddressesModelProvider.notifier)
                            //           .addAddress(
                            //             AddFavoriteAddressRequest(
                            //               regionId: 1,
                            //               address: address.address,
                            //               addressAdditional:
                            //                   address.addressAdditional,
                            //               name: name,
                            //               title: title,
                            //               phone: phone,
                            //             ),
                            //           );
                            //     } else {
                            //       response = await ref
                            //           .read(favoriteAddressesModelProvider.notifier)
                            //           .editAddress(
                            //             widget.editingFavoriteAddress!.id,
                            //             EditFavoriteAddressRequest(
                            //               address: address.address,
                            //               addressAdditional:
                            //                   address.addressAdditional,
                            //               name: name,
                            //               title: title,
                            //               phone: phone,
                            //             ),
                            //           );
                            //     }
                            //
                            //     Navigator.pop(context, response);
                            //   },
                            // ),
                            // if (widget.editingFavoriteAddress != null)
                            //   AppButton(
                            //     title: "Удалить",
                            //     tap: () async {
                            //       if (widget.returnResult) {
                            //         return Navigator.of(context).pop(
                            //           FavoriteAddress(
                            //             id: -2,
                            //             regionId: 1,
                            //             address: "",
                            //             addressAdditional: "",
                            //             name: "",
                            //             title: "",
                            //             phone: "",
                            //           ),
                            //         );
                            //       }
                            //
                            //       var response = await ref
                            //           .read(favoriteAddressesModelProvider.notifier)
                            //           .deleteAddress(
                            //               widget.editingFavoriteAddress!.id);
                            //
                            //       Navigator.pop(context, response);
                            //     },
                            //   ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  PlacemarkMapObject? _userPlaceMark;

  void _onMapTap(Point point) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var pStr = '${point.longitude},${point.latitude}';

      address =
          await ref.read(yandexGeocoderApiProvider).getAddressFromPoint(pStr) ??
              '';

      await _appUserPoint(point);

      if (addressKey.currentState is SetAddressMixin && address.isNotEmpty) {
        var data = AddressFullData(
          MapPosition(latitude: point.latitude, longitude: point.longitude),
          address,
          "",
        );
        (addressKey.currentState as SetAddressMixin).initAddressValue(data);
        print(address);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _appUserPoint(Point point) async {
    setState(() {
      if (_userPlaceMark != null) {
        mapObjects.remove(_userPlaceMark!);
      }
      _userPlaceMark = PlacemarkMapObject(
          opacity: 1.0,
          icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(AppIcons.userPoint),
            scale: AppUi.placeMarkScale,
          )),
          point: point,
          mapId: MapObjectId(point.latitude.toString()));
      setState(() {
        mapObjects.add(_userPlaceMark!);
      });
    });
  }

  TimeRangeData getTimeRangeData(ZonesDelivery zoneDelivery) {
    int zone = zoneDelivery == ZonesDelivery.zone1
        ? 1
        : zoneDelivery == ZonesDelivery.zone2
            ? 2
            : 3;
    double currentHour = deliveryDateTime.hour.toDouble();
    if (deliveryDateTime.minute > 0) {
      currentHour += 0.5;
    }
    return widget.deliveryInfo.timeRanges.timeRangesDefault
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

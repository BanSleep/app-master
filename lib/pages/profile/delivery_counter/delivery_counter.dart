import 'package:collection/collection.dart';
import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:cvetovik/pages/ordering/mixin/address_mixin.dart';
import 'package:cvetovik/pages/ordering/models/address_full_data.dart';
import 'package:cvetovik/pages/ordering/models/map_position.dart';
import 'package:cvetovik/pages/ordering/widgets/address/map_confirm_sheet.dart';
import 'package:cvetovik/pages/ordering/widgets/address/search_address_widget.dart';
import 'package:cvetovik/pages/profile/delivery_counter/widget/counter_bar.dart';
import 'package:cvetovik/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';


class DeliveryCounterPage extends StatefulWidget {
  const DeliveryCounterPage({Key? key, required this.items, required this.position})
      : super(key: key);
  final List<RegionShopInfo> items;
  final MapPosition? position;
  @override
  _DeliveryCounterPageState createState() => _DeliveryCounterPageState();
}

class _DeliveryCounterPageState extends State<DeliveryCounterPage> with AddressMixin {
  List<MapPosition> positions = [];
  late YandexMapController _controller;
  @override
  void initState() {
    //positions = widget.items.map((e) => getPositionFromStr(e.coordinates)).toList();
    widget.items.forEach((element) {
      print(element.coordinates);
      var currPos = getPositionFromStr(
        value: element.coordinates,
      );
      if (currPos != null) {
        positions.add(currPos);
      }
    });
    super.initState();
  }

  final List<MapObject> mapObjects = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          YandexMap(
            mapObjects: mapObjects,
            onMapCreated: (YandexMapController yandexMapController) async {
              _controller = yandexMapController;
              if (widget.position != null) {
                var fixPoint = Point(
                    latitude: widget.position!.latitude,
                    longitude: widget.position!.longitude);
                await _controller.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: fixPoint),
                  ),
                );
              }
              if (positions.isNotEmpty) {
                for (var pos in positions) {
                  mapObjects.add(PlacemarkMapObject(
                      onTap: _onTapPlaceMark,
                      opacity: 1.0,
                      icon: PlacemarkIcon.single(PlacemarkIconStyle(
                        image: BitmapDescriptor.fromAssetImage(
                            AppIcons.shopPoints),
                        scale: AppUi.placeMarkScaleShop,
                      )),
                      point: Point(
                          latitude: pos.latitude, longitude: pos.longitude),
                      mapId: MapObjectId(pos.latitude.toString())));
                }

                await _controller.moveCamera(
                  CameraUpdate.zoomOut(),
                );
                setState(() {});
              }
            },
          ),
          Positioned(
              top: 45.h,
              child: Text(
                AppRes.pickupPoints,
                style: AppTextStyles.titleLarge,
              )),
          Positioned(
            top: 35.h,
            left: 0.w,
            child: AppBackButton(tap: () {
              Navigator.pop(context);
            }),
          ),
          Positioned(
              bottom: 10.h,
              child: CounterBar(selectedAddress: _selectedAddress)),
        ],
      ),
    );
  }

  void _onTapPlaceMark(PlacemarkMapObject point, Point tapReceiver) async {
    var coordinates = '${point.point.latitude},${point.point.longitude}';
    var currShop = widget.items
        .firstWhereOrNull((element) => element.coordinates == coordinates);
    if (currShop != null) {
      var res = await AppUi.showAppBottomSheet(
          context: context,
          child: MapConfirmSheet(
            shop: currShop,
          ),
          isShape: true);
      if (res is bool && res) Navigator.pop(context, currShop);
    }
  }

  Future<void> _selectedAddress(AddressFullData data) async {
    var fixPoint =
    Point(longitude: data.pos.longitude, latitude: data.pos.latitude);
    await _controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: fixPoint),
      ),
    );
  }
}

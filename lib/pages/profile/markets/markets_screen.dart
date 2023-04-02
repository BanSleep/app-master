import 'package:collection/collection.dart';
import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/marker_generator.dart';
import 'package:cvetovik/core/services/providers/markets_provider.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:cvetovik/pages/ordering/mixin/address_mixin.dart';
import 'package:cvetovik/pages/ordering/models/address_full_data.dart';
import 'package:cvetovik/pages/ordering/models/map_position.dart';
import 'package:cvetovik/pages/ordering/widgets/address/map_confirm_sheet.dart';
import 'package:cvetovik/pages/ordering/widgets/address/search_address_widget.dart';
import 'package:cvetovik/pages/profile/markets/models/market_model.dart';
import 'package:cvetovik/pages/profile/markets/models/regions.dart';
import 'package:cvetovik/pages/profile/markets/widget/market_info_bottom.dart';
import 'package:cvetovik/pages/profile/markets/widget/markets_list.dart';
import 'package:cvetovik/pages/profile/markets/widget/region_selector.dart';
import 'package:cvetovik/widgets/app_back_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../core/services/providers/region_shops_provider.dart';

class MarketsPage extends ConsumerStatefulWidget {
  const MarketsPage({Key? key, required this.items, required this.position})
      : super(key: key);
  final List<RegionShopInfo> items;
  final MapPosition? position;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MarketsPageState();
  }
}

class _MarketsPageState extends ConsumerState<MarketsPage>
    with AddressMixin, TickerProviderStateMixin {
  List<MapPosition> positions = [];
  late YandexMapController _controller;
  final List<MapObject> mapObjects = [];
  List<RegionModel> regions = [];
  List<RegionShopInfo> shops = [];
  late TabController tabController;

  getRegions() async {
    var markets = ref.read(marketsProvider);
    var items = await markets.getRegions();

    setState(() {
      regions = items;
    });
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    //positions = widget.items.map((e) => getPositionFromStr(e.coordinates)).toList();
    getRegions();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          TabBarView(physics: NeverScrollableScrollPhysics(),
              controller: tabController,
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
            MarketsList(
              list: shops,
            )
          ]),
          Positioned(
              left: 0,
              right: 0,
              top: 45.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppRes.pickupPoints,
                    style: AppTextStyles.titleLarge,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 38,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Color(0xff000000).withOpacity(0.06),
                          blurRadius: 15,
                          offset: Offset(0, 4),
                          spreadRadius: 0)
                    ],
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    width: double.maxFinite,
                    child: TabBar(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: AppColors.primary),
                        controller: tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab(
                            text: 'На карте',
                          ),
                          Tab(
                            text: 'Списком',
                          ),
                        ]),
                  )
                ],
              )),
          Positioned(
            top: 40.h,
            left: 0.w,
            child: AppBackButton(tap: () {
              Navigator.pop(context);
            }),
          ),
          Positioned(
              right: 0,
              left: 0,
              bottom: 10.h,
              child: RegionSelector(
                list: regions,
                onSelect: (RegionModel region) {
                  print('selected');
                  _getShopList(context, regionId: region.id);
                },
              )),
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

  Point getPointByString(String coordinate) {
    var data = coordinate.split(",");
    print(data.toString());
    return Point(
        latitude: double.parse(data[0].toString()),
        longitude: double.parse(data[1].toString()));
  }

  Future<void> _getShopList(BuildContext context, {int? regionId}) async {

    setState(() {
      mapObjects.clear();
      shops.clear();
    });


    var shopsProv = ref.read(shopsProvider);
    var set = ref.read(settingsProvider);
    var deviceRegister = set.getDeviceRegisterWithRegion();
    List<RegionShopInfo>? items =
        await shopsProv.getRegionShops(deviceRegister, regionId: regionId);

    var shops1 = items!.map((e) {
      var point = getPointByString(e.coordinates);
      return PlacemarkMapObject(
          onTap: (c, point) {
            showMarketInfoBottomSheet(context, e);
          },
          opacity: 1.0,
          icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(AppIcons.shopPoints),
            scale: AppUi.placeMarkScaleShop,
          )),
          point: point,
          mapId: MapObjectId(point.latitude.toString()));
    }).toList();
    print('${shops1.length}' + 'lenght141');
    setState(() {
      shops=items;
      mapObjects.addAll(shops1);
    });
  }

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

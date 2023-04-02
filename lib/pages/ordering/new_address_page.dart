import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/yandex_geocoder_api.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/pages/ordering/models/address_full_data.dart';
import 'package:cvetovik/pages/ordering/models/map_position.dart';
import 'package:cvetovik/pages/ordering/providers/center_position_provider.dart';
import 'package:cvetovik/pages/ordering/widgets/address/select_address_widget.dart';
import 'package:cvetovik/widgets/app_back_button.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'mixin/address_mixin.dart';

class NewAddressPage extends ConsumerStatefulWidget {
  const NewAddressPage({Key? key, this.resizeAvoid = false, this.data})
      : super(key: key);
  final bool resizeAvoid;
  final AddressData? data;

  @override
  _NewAddressPageState createState() => _NewAddressPageState();
}

class _NewAddressPageState extends ConsumerState<NewAddressPage>
    with AddressMixin {
  Future<bool> get locationPermissionGranted async =>
      await Permission.location.request().isGranted;
  late YandexMapController _controller;

  GlobalKey keySelectAddress = GlobalKey();
  bool _isLoading = false;
  final List<MapObject> mapObjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: widget.resizeAvoid,
        body: LoadingOverlay(
          isLoading: _isLoading,
          opacity: AppUi.opacity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              YandexMap(
                  mapObjects: mapObjects,
                  onMapTap: _onMapTap,
                  onMapCreated:
                      (YandexMapController yandexMapController) async {
                    _controller = yandexMapController;

                    Point? fixPoint;
                    if (widget.data != null) {
                      fixPoint = Point(
                          latitude: widget.data!.lat,
                          longitude: widget.data!.long);
                      await _appUserPoint(fixPoint);
                    } else {
                      var prov = ref.read(centerPositionProvider.notifier);
                      if (prov.state != null) {
                        fixPoint = Point(
                            latitude: prov.state!.latitude,
                            longitude: prov.state!.longitude);
                      }
                    }
                    if (fixPoint != null) {
                      await _controller.moveCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(target: fixPoint),
                        ),
                      );
                    }
                  }),
              Positioned(
                  top: 45.h,
                  child: Text(
                    (widget.data != null)
                        ? AppRes.editAddress
                        : AppRes.newAddress,
                    style: AppTextStyles.titleLarge,
                  )),
              Positioned(
                top: 35.h,
                left: 0.w,
                child: AppBackButton(
                  tap: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                  bottom: 10.h,
                  child: SelectAddressWidget(
                    key: keySelectAddress,
                    selectedAddress: _selectedAddress,
                    data: widget.data,
                  )),
            ],
          ),
        ));
  }

  Future<void> _selectedAddress(AddressFullData data) async {
    var fixPoint =
        Point(longitude: data.pos.longitude, latitude: data.pos.latitude);
    await _controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: fixPoint),
      ),
    );
    await _appUserPoint(fixPoint);
  }

  /*Future<void> _selectedAddress2(String title) async {
    var res = await context
        .read(yandexGeocoderApiProvider)
        .getPointFromAddress(title);
    if (res != null && res.isNotEmpty) {
      var currPoint = getPositionFromStr(value: res, invert: true);
      if (currPoint != null) {
        var fixPoint =
            Point(longitude: currPoint.longitude, latitude: currPoint.latitude);
        await _controller.move(point: fixPoint);
      }
    }
  }*/

  PlacemarkMapObject? _userPlaceMark;
  void _onMapTap(Point point) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var pStr = '${point.longitude},${point.latitude}';

      var address =
          await ref.read(yandexGeocoderApiProvider).getAddressFromPoint(pStr);

      await _appUserPoint(point);

      if (keySelectAddress.currentState is SetAddressMixin && address != null) {
        var data = AddressFullData(
          MapPosition(latitude: point.latitude, longitude: point.longitude),
          address,
          "",
        );
        (keySelectAddress.currentState as SetAddressMixin)
            .initAddressValue(data);
        print(address);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _appUserPoint(Point point) async {
    if (_userPlaceMark != null) {
      mapObjects.remove(_userPlaceMark!);
      //await _controller.removePlacemarkMapObject(_userPlaceMark!);
    }
    /*_userPlaceMark = PlacemarkMapObject(
        style: PlacemarkMapObjectStyle(
            opacity: 1.0,
            scale: AppUi.placeMarkScale,
            iconName: AppIcons.userPoint),
        point: Point(latitude: point.latitude, longitude: point.longitude));*/

    _userPlaceMark = PlacemarkMapObject(
        opacity: 1.0,
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage(AppIcons.userPoint),
          scale: AppUi.placeMarkScale,
        )),
        point: point,
        mapId: MapObjectId(point.latitude.toString()));
    mapObjects.add(_userPlaceMark!);
    setState(() {});
    //await _controller.addPlacemarkMapObject(_userPlaceMark!);
  }
}

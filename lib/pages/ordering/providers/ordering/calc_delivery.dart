import 'package:collection/collection.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/pages/ordering/mixin/address_mixin.dart';
import 'package:cvetovik/pages/ordering/models/delivery_param.dart';
import 'package:cvetovik/pages/ordering/models/enums/zones_delivery.dart';
import 'package:intl/intl.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CalcDelivery with AddressMixin {
  final DeliveryInfo deliveryInfo;

  CalcDelivery(this.deliveryInfo);

  int? calc(ZonesDelivery zone, DeliveryParam p) {
    if (p.extractTime) {
      return deliveryInfo.exactTimePrice;
    }
    if (p.timeRange == null) {
      return null;
    }
    TimeRangeData data = p.timeRange!;
    if (data.freeFrom > 0 &&
        p.price >= data.freeFrom &&
        zone == ZonesDelivery.zone1) {
      return 0;
    }
    var km = getDistanceKm();
    switch (zone) {
      case ZonesDelivery.none:
        return null;
      case ZonesDelivery.zone1:
        return data.price;
      case ZonesDelivery.zone2:
        if ((data.startHour >= 21 || data.stopHour <= 9) &&
            km > 0 &&
            data.kmPrice > 0) {
          var res = data.fullPrice(km);
          return res;
        } else {
          return data.price;
        }
      case ZonesDelivery.zone3:
        var res = data.fullPrice(km);
        print('deliveryPrice for zone3 $res');
        return res;
    }
  }

  int getDistanceKm() {
    if (_distance != null) {
      var res = (_distance! / 1000).floor();
      return res;
    } else {
      return 0;
    }
  }

  Future<int?> distanceFromZone1(
    LatLng currPoint,
  ) async {
    _distance = null;
    var centerPoint = getLatLng(deliveryInfo.mapCenter);
    var zoneKey = _getZoneKeyByDate();
    var currZones = deliveryInfo.zones![zoneKey];
    var rawPoints = currZones!.zone1;
    var resultWithSession = YandexDriving.requestRoutes(
      points: [
        RequestPoint(
            point: Point(
                latitude: centerPoint!.latitude,
                longitude: centerPoint.longitude),
            requestPointType: RequestPointType.wayPoint),
        RequestPoint(
            point: Point(
                latitude: currPoint.latitude, longitude: currPoint.longitude),
            requestPointType: RequestPointType.wayPoint),
      ],
      drivingOptions: DrivingOptions(),
    );
    var result = await resultWithSession.result;
    if (result.routes != null && result.routes!.isNotEmpty) {
      var currRoute = result.routes!.reduce((current, next) =>
          current.metadata.weight.distance.value! <
                  next.metadata.weight.distance.value!
              ? current
              : next);
      //var currRoute = result.routes!.first;
      var middleIndex = (currRoute.geometry.length / 2).ceil();
      var middlePoint = currRoute.geometry[middleIndex];
      Point? zoneOneEndPoint;
      var foundFirstZonePoint = _checkZone(
          LatLng(middlePoint.latitude, middlePoint.longitude), rawPoints);

      late int startIndex;
      late int endIndex;

      if (foundFirstZonePoint) {
        startIndex = middleIndex;
        endIndex = currRoute.geometry.length;
      } else {
        startIndex = 0;
        endIndex = middleIndex;
      }

      middleIndex = (endIndex / 2).round();
      middlePoint = currRoute.geometry[middleIndex];
      foundFirstZonePoint = _checkZone(
          LatLng(middlePoint.latitude, middlePoint.longitude), rawPoints);
      if (foundFirstZonePoint) {
        startIndex = middleIndex;
        endIndex = currRoute.geometry.length;
      } else {
        startIndex = 0;
        endIndex = middleIndex;
      }

      middleIndex = (endIndex / 2).round();
      middlePoint = currRoute.geometry[middleIndex];
      foundFirstZonePoint = _checkZone(
          LatLng(middlePoint.latitude, middlePoint.longitude), rawPoints);
      if (foundFirstZonePoint) {
        startIndex = middleIndex;
        endIndex = currRoute.geometry.length;
      } else {
        startIndex = 0;
        endIndex = middleIndex;
      }

      //int startNewIndex = 0;
      for (var i = startIndex; i <= endIndex; i++) {
        print('***** --- $i');
        if (i < 0) {
          break;
        }
        var curr = currRoute.geometry[i];
        foundFirstZonePoint =
            _checkZone(LatLng(curr.latitude, curr.longitude), rawPoints);
        if (!foundFirstZonePoint) {
          //startNewIndex = i + 70;
          zoneOneEndPoint = currRoute.geometry[i];
          break;
        }
      }

      /*List<Point> geometryWayPath = [];
      if (startNewIndex > 0) {
        for (var i = startNewIndex; i <= currRoute.geometry.length - 1; i++) {
          var curr = currRoute.geometry[i];
          geometryWayPath.add(curr);
        }
      }*/

      if (zoneOneEndPoint != null) {
        List<RequestPoint> points = [];
        points.add(
          RequestPoint(
              point: zoneOneEndPoint,
              requestPointType: RequestPointType.wayPoint),
        );

        /*geometryWayPath.forEach((el) {
          var point = RequestPoint(
              point: el, requestPointType: RequestPointType.viaPoint);
          points.add(point);
        });*/

        points.add(
          RequestPoint(
              point: Point(
                  latitude: currPoint.latitude, longitude: currPoint.longitude),
              requestPointType: RequestPointType.wayPoint),
        );

        resultWithSession = YandexDriving.requestRoutes(
            drivingOptions: DrivingOptions(),
            points:
                points /*[
          RequestPoint(
              point: zoneOneEndPoint,
              requestPointType: RequestPointType.wayPoint),
          RequestPoint(
              point: Point(
                  latitude: currPoint.latitude, longitude: currPoint.longitude),
              requestPointType: RequestPointType.wayPoint),
        ]*/
            );
        result = await resultWithSession.result;
        if (result.routes != null && result.routes!.isNotEmpty) {
          currRoute = result.routes!.reduce((current, next) =>
              current.metadata.weight.distance.value! <
                      next.metadata.weight.distance.value!
                  ? current
                  : next);
          //currRoute = result.routes!.first;
          var raw = currRoute.metadata.weight.distance.value;
          if (raw != null) {
            int distance = raw.floor();
            return distance;
          }
        }
      }
    }
    return null;
  }

  Future<ZonesDelivery> getZone(LatLng currPoint) async {
    var zoneKey = _getZoneKeyByDate();
    var currZones = deliveryInfo.zones![zoneKey];
    var zone = await _getZoneFromCurr(currZones, currPoint);
    return zone;
  }

  String _getZoneKeyByDate() {
    final DateFormat formattedDate = DateFormat(AppUi.dateFormatStr);
    var dateKey = formattedDate.format(DateTime.now());
    //dateKey = '08.03.2022';
    var curr = deliveryInfo.zones!.keys.firstWhereOrNull((el) => el == dateKey);
    if (curr != null)
      return curr;
    else
      return deliveryInfo.zones!.keys.first;
  }

  int? get distance => _distance;
  int? _distance;
  Future<ZonesDelivery> _getZoneFromCurr(
      ZoneData? currZones, LatLng currPoint) async {
    var rawPoints = currZones!.zone1;
    var res = _checkZone(currPoint, rawPoints);
    if (res) {
      return ZonesDelivery.zone1;
    }
    rawPoints = currZones.zone2;
    res = _checkZone(currPoint, rawPoints);
    if (res) {
      _distance = await distanceFromZone1(currPoint);
      return ZonesDelivery.zone2;
    }
    rawPoints = currZones.zone1;
    if (rawPoints != null) {
      var centerPoint = getLatLng(deliveryInfo.mapCenter);
      if (centerPoint != null) {
        res = await _checkZone3(
          currZones.zone3Limit,
          currPoint,
        );
        if (res) {
          return ZonesDelivery.zone3;
        }
      }
    }
    return ZonesDelivery.none;
  }

  bool _checkZone(LatLng point, String? rawPoints) {
    if (rawPoints == null || rawPoints.isEmpty) return false;
    List<LatLng> pointList = _getPointList(rawPoints);
    var res = PolygonUtil.containsLocation(point, pointList, true);
    return res;
  }

  List<LatLng> _getPointList(String rawPoints) {
    rawPoints = rawPoints.substring(1, rawPoints.length - 1);
    var rawList = rawPoints.split('],[');
    var first = rawList[0];
    first = first.replaceAll('[', '');
    rawList[0] = first;

    var last = rawList[rawList.length - 1];
    last = last.replaceAll(']', '');
    rawList[rawList.length - 1] = last;
    print(rawList.length);
    var pointList = rawList.map((e) => _strToLatLng(e)).toList();
    return pointList;
  }

  LatLng _strToLatLng(String e) {
    var item = e.split(',');
    var lat = double.tryParse(item[0]);
    var lng = double.tryParse(item[1]);
    return LatLng(lat!, lng!);
  }

  LatLng? getLatLng(String value) {
    List<String> positions = value.split(',');
    if (positions.isNotEmpty && positions.length == 2) {
      var lat = double.tryParse(positions[0].trim());
      var long = double.tryParse(positions[1].trim());
      if (lat != null && long != null) {
        return LatLng(lat, long);
      }
    }
    return null;
  }

  Future<bool> _checkZone3(
    int zone3limit,
    LatLng currPoint,
  ) async {
    _distance = await distanceFromZone1(currPoint);
    if (_distance != null) {
      var result = (_distance! < (zone3limit * 1000));
      return result;
    }
    return false;
  }
}

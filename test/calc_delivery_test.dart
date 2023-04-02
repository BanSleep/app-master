import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/pages/ordering/models/delivery_param.dart';
import 'package:cvetovik/pages/ordering/models/enums/zones_delivery.dart';
import 'package:cvetovik/pages/ordering/providers/ordering/calc_delivery.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

import 'calc_delivery_test_helper.dart';

void main() {
  test('test calc_delivery with zones', () async {
    try {
      print('test calc_delivery with zones');
      print('start zone1');
      //region zone1;
      LatLng currPoint = LatLng(59.881729, 30.314958);
      var deliveryInfo = getDeliveryInfo();
      var calc = CalcDelivery(deliveryInfo);
      var zone = await calc.getZone(currPoint);
      expect(zone == ZonesDelivery.zone1, true);

      var tr = TimeRangeData.fromJson({
        "zone": 1,
        "start_hour": 2,
        "stop_hour": 4,
        "close_hour": 2,
        "price": 350,
        "free_from": 0,
        "km_price": 0
      });
      var p = DeliveryParam(
        extractTime: false,
        price: 3999,
        timeRange: tr,
      );
      var res = calc.calc(zone, p);
      expect(res! == 350, true);

      p = DeliveryParam(
        extractTime: false,
        price: 4500,
        timeRange: tr,
      );
      res = calc.calc(zone, p);
      expect(res! == 350, true);

      tr = TimeRangeData.fromJson({
        "zone": 1,
        "start_hour": 12,
        "stop_hour": 14,
        "close_hour": 12,
        "price": 299,
        "free_from": 4000,
        "km_price": 0
      });
      p = DeliveryParam(
        extractTime: false,
        price: 3999,
        timeRange: tr,
      );
      res = calc.calc(zone, p);
      expect(res! == 299, true);

      p = DeliveryParam(
        extractTime: false,
        price: 4000,
        timeRange: tr,
      );
      res = calc.calc(zone, p);
      expect(res! == 0, true);
      print('zone1 ok');
      //endregion

      //region zone2
      currPoint = LatLng(59.715759, 30.405849);
      zone = await calc.getZone(currPoint);
      expect(zone == ZonesDelivery.zone2, true);

      tr = TimeRangeData.fromJson({
        "zone": 2,
        "start_hour": 0,
        "stop_hour": 3,
        "close_hour": 0,
        "price": 350,
        "free_from": 0,
        "km_price": 35
      });
      p = DeliveryParam(
        extractTime: false,
        price: 3999,
        timeRange: tr,
      );
      res = calc.calc(zone, p);
      var price = 350 + (10 * 35);
      expect(res! == price, true);

      tr = TimeRangeData.fromJson({
        "zone": 2,
        "start_hour": 12,
        "stop_hour": 15,
        "close_hour": 12,
        "price": 350,
        "free_from": 0,
        "km_price": 0
      });
      res = calc.calc(zone, p);
      p = DeliveryParam(
        extractTime: false,
        price: 3999,
        timeRange: tr,
      );
      res = calc.calc(zone, p);
      expect(res! == 350, true);
      //endregion

      //region zone none

      currPoint = LatLng(60.548181, 30.237429);
      zone = await calc.getZone(currPoint);
      expect(zone == ZonesDelivery.none, true);

      currPoint = LatLng(59.397133, 30.302258);
      zone = await calc.getZone(currPoint);
      expect(zone == ZonesDelivery.none, true);

      currPoint = LatLng(60.252021, 29.603201);
      zone = await calc.getZone(currPoint);
      expect(zone == ZonesDelivery.none, true);

      //endregion

      //region region3

      currPoint = LatLng(60.019587, 30.673198);
      zone = await calc.getZone(currPoint);
      expect(zone == ZonesDelivery.zone3, true);

      tr = TimeRangeData.fromJson({
        "zone": 3,
        "start_hour": 22,
        "stop_hour": 2,
        "close_hour": 22,
        "price": 350,
        "free_from": 0,
        "km_price": 35
      });
      p = DeliveryParam(
        extractTime: false,
        price: 3999,
        timeRange: tr,
      );
      res = calc.calc(zone, p);
      //expect(res == 700, true);
      //endregion
    } on Exception catch (e, st) {
      print('**************************************');
      print(st.toString());
    }
  });
}

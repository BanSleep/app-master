// To parse this JSON data, do
//
//     final deliveryInfoResponse = deliveryInfoResponseFromJson(jsonString);

import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:cvetovik/models/api/response/base/app_base_response.dart';
import 'package:cvetovik/models/api/response/base/time_range_base.dart';
import 'package:intl/intl.dart';

DeliveryInfoResponse deliveryInfoResponseFromJson(String str) =>
    DeliveryInfoResponse.fromJson(json.decode(str));

//String deliveryInfoResponseToJson(DeliveryInfoResponse data) => json.encode(data.toJson());

class DeliveryInfoResponse extends AppBaseResponse {
  DeliveryInfoResponse({
    required result,
    this.data,
  }) : super(result);

  DeliveryInfo? data;

  factory DeliveryInfoResponse.fromJson(Map<String, dynamic> json) {
    log("delivery info from json ${DeliveryInfo.fromJson(json["data"]).zones}");
    return DeliveryInfoResponse(
      result: json["result"],
      data: DeliveryInfo.fromJson(json["data"]),
    );
  }

/*Map<String, dynamic> toJson() => {
    "result": result,
    "data": (data !=null) ? data!.toJson() : null,
  };*/
}

class DeliveryInfo {
  DeliveryInfo({
    required this.id,
    required this.selfMinSum,
    required this.deliveryMinSum,
    required this.exactTimePrice,
    required this.mapCenter,
    this.zones,
    this.exactStopDate,
    required this.timeRanges,
  });

  int id;
  int selfMinSum;
  int deliveryMinSum;
  int exactTimePrice;
  String mapCenter;
  Map<String, ZoneData>? zones;
  String? exactStopDate;
  TimeRanges timeRanges;

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) {
    try {
      // log("time ranges from response: ${TimeRanges.fromJson(json["time_ranges"]).toJson()}");
      var res = DeliveryInfo(
        id: json["id"],
        selfMinSum: json["self_min_sum"],
        deliveryMinSum: json["delivery_min_sum"],
        exactTimePrice: json["exact_time_price"],
        exactStopDate: json["exact_stop_date"],
        mapCenter: json["map_center"],
        zones: Map.from(json["zones"])
            .map((k, v) => MapEntry<String, ZoneData>(k, ZoneData.fromJson(v))),
        timeRanges: TimeRanges.fromJson(json["time_ranges"]),
      );
      return res;
    } catch (ex) {
      print(ex);
      throw ('error');
    }
  }

/*Map<String, dynamic> toJson() => {
    "id": id,
    "self_min_sum": selfMinSum,
    "delivery_min_sum": deliveryMinSum,
    "exact_time_price": exactTimePrice,
    "map_center": mapCenter,
    "zones": Map.from(zones).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "time_ranges": timeRanges.toJson(),
  };*/
}

class TimeRanges {
  TimeRanges({
    required this.timeRangesDefault,
    // required List<List<TimeRangeData>> timeRangesAll,
    required this.timeRangesAll,
  });

  List<TimeRangeData> timeRangesDefault;
  Map<String, List<TimeRangeData>> timeRangesAll = new HashMap();

  factory TimeRanges.fromJson(Map<String, dynamic> json) {
    DateTime t = DateTime.now();

    String dateFormatted = "${DateFormat('dd.MM.yyyy').format(t)}";

    String dateKey = (json[dateFormatted] != null ? dateFormatted : "default");
    log("today date formatted: ${dateFormatted}");
    log("today date key: ${dateKey}");

    Map<String, List<TimeRangeData>> tra = new HashMap();
    for (var k in json.keys) {
      tra[k] = (List<TimeRangeData>.from(
          json[k].map((x) => TimeRangeData.fromJson(x))));
    }

    return TimeRanges(
      timeRangesDefault: List<TimeRangeData>.from(
          json["default"].map((x) => TimeRangeData.fromJson(x))),
      timeRangesAll: tra,
    );
  }

  Map<String, dynamic> toJson() => {
        "default": List<dynamic>.from(timeRangesDefault.map((x) => x.toJson())),
      };
}

class TimeRangeData extends TimeRangeBase {
  TimeRangeData({
    required startHour,
    required stopHour,
    required closeHour,
    required this.zone,
    required this.price,
    required this.freeFrom,
    required this.kmPrice,
  }) : super(startHour, stopHour, closeHour);

  int zone;
  int price;
  int freeFrom;
  int kmPrice;

  int fullPrice(int km) {
    return price + (km * kmPrice);
  }

  factory TimeRangeData.fromJson(Map<String, dynamic> json) => TimeRangeData(
        zone: json["zone"],
        startHour: json["start_hour"],
        stopHour: json["stop_hour"],
        closeHour: json["close_hour"],
        price: json["price"],
        freeFrom: json["free_from"],
        kmPrice: json["km_price"],
      );

  Map<String, dynamic> toJson() => {
        "zone": zone,
        "start_hour": startHour,
        "stop_hour": stopHour,
        "close_hour": closeHour,
        "price": price,
        "free_from": freeFrom,
        "km_price": kmPrice,
      };
}

class ZoneData {
  ZoneData({
    required this.zone1,
    required this.zone2,
    required this.zone3Limit,
  });

  String? zone1;
  String? zone2;
  int zone3Limit;

  factory ZoneData.fromJson(Map<String, dynamic> json) {
    var res = ZoneData(
      zone1: json["zone1"] == null ? null : json["zone1"],
      zone2: json["zone2"] == null ? null : json["zone2"],
      zone3Limit: json["zone3_limit"],
    );
    return res;
  }

  Map<String, dynamic> toJson() => {
        "zone1": zone1,
        "zone2": zone2 == null ? null : zone2,
        "zone3_limit": zone3Limit,
      };
}

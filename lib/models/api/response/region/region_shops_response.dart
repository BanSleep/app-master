// To parse this JSON data, do
//
//     final regionShopsResponse = regionShopsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:cvetovik/models/api/response/base/app_base_response.dart';
import 'package:cvetovik/models/api/response/base/time_range_base.dart';

RegionShopsResponse regionShopsResponseFromJson(String str) =>
    RegionShopsResponse.fromJson(json.decode(str));

//String regionShopsResponseToJson(RegionShopsResponse data) => json.encode(data.toJson());

class RegionShopsResponse extends AppBaseResponse {
  RegionShopsResponse({
    required result,
    this.data,
  }) : super(result);

  final Map<String, RegionShopInfo>? data;

  factory RegionShopsResponse.fromJson(Map<String, dynamic> json) =>
      RegionShopsResponse(
        result: json["result"],
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, RegionShopInfo>(k, RegionShopInfo.fromJson(v))),
      );

  /*Map<String, dynamic> toJson() => {
    "result": result,
    "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };*/
}

class RegionShopInfo {
  RegionShopInfo({
    required this.id,
    required this.title,
    required this.metro,
    required this.address,
    required this.contacts,
    required this.coordinates,
    required this.workTime,
    required this.timeRanges,
  });

  int id;
  String title;
  String metro;
  String address;
  String contacts;
  String coordinates;
  String workTime;
  List<ShopTimeRange> timeRanges;

  factory RegionShopInfo.fromJson(Map<String, dynamic> json) {
    var res = RegionShopInfo(
      id: json["id"],
      title: json["title"],
      metro: json["metro"],
      address: json["address"],
      contacts: json["contacts"],
      coordinates: json["coordinates"],
      workTime: json["work_time"],
      timeRanges: json["time_ranges"] != null
          ? List<ShopTimeRange>.from(
              json["time_ranges"].map((x) => ShopTimeRange.fromJson(x)))
          : [],
    );
    return res;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "metro": metro,
        "address": address,
        "contacts": contacts,
        "coordinates": coordinates,
        "work_time": workTime,
      };
}

class ShopTimeRange extends TimeRangeBase {
  ShopTimeRange({
    required startHour,
    required stopHour,
    required closeHour,
  }) : super(int.parse(startHour), int.parse(stopHour), int.parse(closeHour));

  factory ShopTimeRange.fromJson(Map<String, dynamic> json) => ShopTimeRange(
        startHour: json["start_hour"],
        stopHour: json["stop_hour"],
        closeHour: json["close_hour"],
      );

  Map<String, dynamic> toJson() => {
        "start_hour": startHour,
        "stop_hour": stopHour,
        "close_hour": closeHour,
      };
}

// To parse this JSON data, do
//
//     final regionResponse = regionResponseFromJson(jsonString);

import 'dart:convert';

import 'package:cvetovik/models/api/response/base/app_base_response.dart';

RegionResponse regionResponseFromJson(String str) =>
    RegionResponse.fromJson(json.decode(str));

String regionResponseToJson(RegionResponse data) => json.encode(data.toJson());

class RegionResponse extends AppBaseResponse {
  RegionResponse({
    required result,
    required this.data,
  }) : super(result);

  Map<String, Region> data;

  factory RegionResponse.fromJson(Map<String, dynamic> json) => RegionResponse(
        result: json["result"],
        data: Map.from(json["data"])
            .map((k, v) => MapEntry<String, Region>(k, Region.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": Map.from(data)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class Region {
  Region({
    required this.id,
    required this.title,
    required this.areaTitle,
  });

  int id;
  String title;
  String areaTitle;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["id"],
        title: json["title"],
        areaTitle: json["area_title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "area_title": areaTitle,
      };
}

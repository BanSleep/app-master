// To parse this JSON data, do
//
//     final catalogResponse = catalogResponseFromJson(jsonString);

import 'dart:convert';

import 'package:cvetovik/models/api/response/base/app_base_response.dart';

CatalogResponse catalogResponseFromJson(String str) =>
    CatalogResponse.fromJson(json.decode(str));

//String catalogResponseToJson(CatalogResponse data) => json.encode(data.toJson());

class CatalogResponse extends AppBaseResponse {
  CatalogResponse({
    result,
    this.data,
  }) : super(result);

  Map<String, CatalogData>? data;

  CatalogResponse copyWith({
    required bool result,
    required Map<String, CatalogData> data,
  }) =>
      CatalogResponse(
        result: result,
        data: data,
      );

  factory CatalogResponse.fromJson(Map<String, dynamic> json) {
    if (json["data"] == null) {
      print('alarm');
    }
    var res = CatalogResponse(
      result: json["result"],
      data: Map.from(json["data"]).map(
          (k, v) => MapEntry<String, CatalogData>(k, CatalogData.fromJson(v))),
    );
    return res;
  }
}

class CatalogData {
  CatalogData(
      {required this.id,
      required this.parentId,
      required this.isGroup,
      required this.title,
      required this.url,
      required this.image,
      this.productsNum});

  int id;
  int parentId;
  bool isGroup;
  String title;
  String url;
  String? image;
  String? productsNum;

  factory CatalogData.fromJson(Map<String, dynamic> json) => CatalogData(
      id: json["id"],
      parentId: json["parent_id"],
      isGroup: json["is_group"],
      title: json["title"],
      url: json["url"],
      image: json["image"],
      productsNum: json['products_num']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "is_group": isGroup,
        "title": title,
        "url": url,
        "image": image
      };
}

// To parse this JSON data, do
//
//     final linkedDecorsResponse = linkedDecorsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:cvetovik/models/api/response/base/app_base_response.dart';

LinkedDecorsResponse linkedDecorsResponseFromJson(String str) =>
    LinkedDecorsResponse.fromJson(json.decode(str));

class LinkedDecorsResponse extends AppBaseResponse {
  LinkedDecorsResponse({
    result,
    this.data,
  }) : super(result);

  Map<String, LinkedDecor>? data;

  factory LinkedDecorsResponse.fromJson(Map<String, dynamic> json) =>
      LinkedDecorsResponse(
        result: json["result"],
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, LinkedDecor>(k, LinkedDecor.fromJson(v))),
      );
}

class LinkedDecor {
  LinkedDecor({
    required this.id,
    required this.title,
    required this.products,
  });

  int id;
  String title;
  Map<String, DecorProduct> products;

  factory LinkedDecor.fromJson(Map<String, dynamic> json) => LinkedDecor(
        id: json["id"],
        title: json["title"],
        products: Map.from(json["products"]).map((k, v) =>
            MapEntry<String, DecorProduct>(k, DecorProduct.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "products": Map.from(products)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class DecorProduct {
  DecorProduct({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
  });

  int id;
  String title;
  String image;
  int price;

  factory DecorProduct.fromJson(Map<String, dynamic> json) => DecorProduct(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "price": price,
      };
}

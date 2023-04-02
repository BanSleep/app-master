// To parse this JSON data, do
//
//     final linkedProductsResponse = linkedProductsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:cvetovik/models/api/response/product_response.dart';

import '../base/app_base_response.dart';

LinkedProductsResponse linkedProductsResponseFromJson(String str) =>
    LinkedProductsResponse.fromJson(json.decode(str));

class LinkedProductsResponse extends AppBaseResponse {
  LinkedProductsResponse({
    result,
    this.data,
  }) : super(result);

  Map<String, LinkedProduct>? data;

  factory LinkedProductsResponse.fromJson(Map<String, dynamic> json) =>
      LinkedProductsResponse(
        result: json["result"],
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, LinkedProduct>(k, LinkedProduct.fromJson(v))),
      );
}

class LinkedProduct {
  LinkedProduct({
    required this.id,
    required this.title,
    required this.products,
  });

  int id;
  String title;
  Map<String, ProductData> products;

  factory LinkedProduct.fromJson(Map<String, dynamic> json) {
    var res = LinkedProduct(
      id: json["id"],
      title: json["title"],
      products: Map.from(json["products"]).map(
          (k, v) => MapEntry<String, ProductData>(k, ProductData.fromJson(v))),
    );
    return res;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "products": Map.from(products)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}
/*
class ProductData {
  ProductData({
    required this.id,
    required this.sku,
    required this.title,
    required this.image,
    required this.price,
    required this.maxPrice,
    required this.regularPrice,
    required this.priceTime,
    required this.bonus,
    required this.badges,
  });

  int id;
  String sku;
  String title;
  String image;
  int price;
  int maxPrice;
  int regularPrice;
  int priceTime;
  int bonus;
  List<dynamic> badges;

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
    id: json["id"],
    sku: json["sku"],
    title: json["title"],
    image: json["image"],
    price: json["price"],
    maxPrice: json["max_price"],
    regularPrice: json["regular_price"],
    priceTime: json["price_time"],
    bonus: json["bonus"],
    badges: List<dynamic>.from(json["badges"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sku": sku,
    "title": title,
    "image": image,
    "price": price,
    "max_price": maxPrice,
    "regular_price": regularPrice,
    "price_time": priceTime,
    "bonus": bonus,
    "badges": List<dynamic>.from(badges.map((x) => x)),
  };
}
 */

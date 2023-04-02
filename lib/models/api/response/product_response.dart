// To parse this JSON data, do
//
//     final productsResponse = productsResponseFromJson(jsonString);

import 'dart:convert';

import 'base/app_base_response.dart';

ProductsResponse productsResponseFromJson(String str) =>
    ProductsResponse.fromJson(json.decode(str));

class ProductsResponse extends AppBaseResponse {
  ProductsResponse({
    required result,
    this.data,
  }) : super(result);

  List<ProductData>? data;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      ProductsResponse(
        result: json["result"],
        data: List<ProductData>.from(
            json["data"].map((x) => ProductData.fromJson(x))),
      );
}

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
    required this.pickUpPayments,
    required this.courierPayments,
    this.badges,
    this.averageMark,
  });

  final int id;
  final String sku;
  final String title;
  final String image;
  final int price;
  final int maxPrice;
  final int regularPrice;
  final int priceTime;
  final int bonus;
  final List<String> courierPayments;
  final List<String> pickUpPayments;
  final List<String>? badges;
  final double? averageMark;

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      courierPayments:[],
      pickUpPayments: [],
      id: json["id"],
      sku: json["sku"],
      title: json["title"],
      image: json["image"],
      price: json["price"],
      maxPrice: json["max_price"],
      regularPrice: json["regular_price"],
      priceTime: json["price_time"],
      bonus: json["bonus"],
      badges: List<String>.from(json["badges"].map((x) => x.toString())),
      averageMark: double.parse(json["average_mark"].toString()),
    );
  }
}

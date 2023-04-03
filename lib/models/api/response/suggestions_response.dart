// To parse this JSON data, do
//
//     final productsResponse = productsResponseFromJson(jsonString);

import 'dart:convert';

import 'base/app_base_response.dart';

SuggestionsResponse suggestionsResponseFromJson(String str) =>
    SuggestionsResponse.fromJson(json.decode(str));

class SuggestionsResponse extends AppBaseResponse {
  SuggestionsResponse({
    required result,
    this.data,
  }) : super(result);

  List<SuggestionsData>? data;

  factory SuggestionsResponse.fromJson(Map<String, dynamic> json) =>
      SuggestionsResponse(
        result: json["result"],
        data: List<SuggestionsData>.from(
            json["data"].map((x) => SuggestionsData.fromJson(x))),
      );
}

class SuggestionsData {
  SuggestionsData({
    required this.id,
    required this.sku,
    required this.title,
    required this.image,
    required this.price,
    required this.maxPrice,
    required this.regularPrice,
    required this.priceTime,
    required this.bonus,
    required this.order,
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
  final List<String>? badges;
  final double? averageMark;
  final int order;

  factory SuggestionsData.fromJson(Map<String, dynamic> json) {
    return SuggestionsData(
      order: json['order'],
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

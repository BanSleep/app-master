// To parse this JSON data, do
//
//     final productCardResponse = productCardResponseFromJson(jsonString);

import 'dart:convert';

import 'base/app_base_response.dart';

ProductCardResponse productCardResponseFromJson(String str) =>
    ProductCardResponse.fromJson(json.decode(str));

//String productCardResponseToJson(ProductCardResponse data) => json.encode(data.toJson());

class ProductCardResponse extends AppBaseResponse {
  ProductCardResponse({
    required result,
    this.data,
  }) : super(result);

  ProductCardData? data;

  factory ProductCardResponse.fromJson(Map<String, dynamic> json) =>
      ProductCardResponse(
        result: json["result"],
        data: ProductCardData.fromJson(json["data"]),
      );

  /*Map<String, dynamic> toJson() => {
    "result": result,
    "data": data.toJson(),
  };*/
}

class ProductCardData {
  ProductCardData({
    required this.id,
    required this.catalogId,
    required this.title,
    required this.sku,
    this.days,
    required this.mainImage,
    required this.additionalImages,
    required this.versions,
    required this.descriptionShort,
    required this.descriptionFull,
    this.averageMark,
    required this.commentsNum,
    required this.badges,
  });

  int id;
  int catalogId;
  String title;
  String sku;
  dynamic days;
  String mainImage;
  List<String> additionalImages;
  List<Version>? versions;
  String descriptionShort;
  String descriptionFull;
  int? averageMark;
  int commentsNum;
  List<String>? badges;

  factory ProductCardData.fromJson(Map<String, dynamic> json) =>
      ProductCardData(
        id: json["id"],
        catalogId: json["catalog_id"],
        title: json["title"],
        sku: json["sku"],
        days: json["days"],
        mainImage: json["main_image"],
        additionalImages:
            List<String>.from(json["additional_images"].map((x) => x)),
        versions: List<Version>.from(
            json["versions"].map((x) => Version.fromJson(x))),
        descriptionShort: json["description_short"],
        descriptionFull: json["description_full"],
        averageMark: json["average_mark"],
        commentsNum: json["comments_num"],
        badges: List<String>.from(json["badges"].map((x) => x.toString())),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "catalog_id": catalogId,
        "title": title,
        "sku": sku,
        "days": days,
        "main_image": mainImage,
        "additional_images": List<dynamic>.from(additionalImages.map((x) => x)),
        //"versions": List<dynamic>.from(versions.map((x) => x.toJson())),
        "description_short": descriptionShort,
        "description_full": descriptionFull,
        "average_mark": averageMark,
        "comments_num": commentsNum,
      };
}

class Version {
  Version({
    this.id,
    required this.title,
    required this.prices,
  });
  int? id;
  String title;
  List<ProductCardPrice> prices;

  factory Version.fromJson(Map<String, dynamic> json) => Version(
        id: json["id"],
        title: json["title"],
        prices: List<ProductCardPrice>.from(
            json["prices"].map((x) => ProductCardPrice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "prices": List<dynamic>.from(prices.map((x) => x.toJson())),
      };
}

class ProductCardPrice {
  ProductCardPrice({
    required this.minNum,
    required this.price,
    required this.bonus,
    required this.regularPrice,
    required this.finishTime,
  });

  int minNum;
  int price;
  int bonus;
  dynamic regularPrice;
  int finishTime;

  factory ProductCardPrice.fromJson(Map<String, dynamic> json) =>
      ProductCardPrice(
        minNum: json["min_num"],
        price: json["price"],
        bonus: json["bonus"],
        regularPrice: json["regular_price"],
        finishTime: json["finish_time"],
      );

  Map<String, dynamic> toJson() => {
        "min_num": minNum,
        "price": price,
        "bonus": bonus,
        "regular_price": regularPrice,
        "finish_time": finishTime,
      };
}

// To parse this JSON data, do
//
//     final regionInfoResponse = regionInfoResponseFromJson(jsonString);

import 'dart:convert';

import '../base/app_base_response.dart';

RegionInfoResponse regionInfoResponseFromJson(String str) =>
    RegionInfoResponse.fromJson(json.decode(str));

String regionInfoResponseToJson(RegionInfoResponse data) =>
    json.encode(data.toJson());

class RegionInfoResponse extends AppBaseResponse {
  RegionInfoResponse({
    required result,
    this.data,
  }) : super(result);

  final RegionInfo? data;

  factory RegionInfoResponse.fromJson(Map<String, dynamic> json) =>
      RegionInfoResponse(
        result: json["result"],
        data: RegionInfo.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": (data != null) ? data!.toJson() : null,
      };
}

class RegionInfo {
  RegionInfo({
    required this.id,
    required this.title,
    required this.areaTitle,
    required this.phoneCode,
    required this.phoneNumber,
    required this.phone,
    required this.textProductTabWarranty,
    required this.textProductTabPayment,
    required this.textProductTabDelivery,
    required this.textProductButtonDelivery,
    required this.textProductButtonPhotoControl,
    required this.textProductButtonFreeCard,
    required this.payments,
    required this.oneClickAvailable,
    this.promos,
  });

  final int id;
  final String title;
  final String areaTitle;
  final String phoneCode;
  final String phoneNumber;
  final String phone;
  final String textProductTabWarranty;
  final bool oneClickAvailable;
  final String textProductTabPayment;
  final String textProductTabDelivery;
  final String textProductButtonDelivery;
  final String textProductButtonPhotoControl;
  final String textProductButtonFreeCard;
  final PaymentMethods? payments;
  final Promos? promos;

  factory RegionInfo.fromJson(Map<String, dynamic> json) => RegionInfo(

    oneClickAvailable: json['one_click_order_available'],
      id: json["id"],
      title: json["title"],
      areaTitle: json["area_title"],
      phoneCode: json["phone_code"],
      phoneNumber: json["phone_number"],
      phone: json["phone"],
      textProductTabWarranty: json["text_product_tab_warranty"],
      textProductTabPayment: json["text_product_tab_payment"],
      textProductTabDelivery: json["text_product_tab_delivery"],
      textProductButtonDelivery: json["text_product_button_delivery"],
      textProductButtonPhotoControl: json["text_product_button_photo_control"],
      textProductButtonFreeCard: json["text_product_button_free_card"],
      promos: json["promos"] != null ? Promos.fromJson(json["promos"]) : null,
      payments: json["payment_methods_available"] != null
          ? PaymentMethods.fromJson(json["payment_methods_available"])
          : null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "area_title": areaTitle,
        "phone_code": phoneCode,
        "phone_number": phoneNumber,
        "phone": phone,
        "text_product_tab_warranty": textProductTabWarranty,
        "text_product_tab_payment": textProductTabPayment,
        "text_product_tab_delivery": textProductTabDelivery,
        "text_product_button_delivery": textProductButtonDelivery,
        "text_product_button_photo_control": textProductButtonPhotoControl,
        "text_product_button_free_card": textProductButtonFreeCard,
        "payments": payments,
      };
}

class PaymentMethods {
  final List<String> pickUp;
  final List<String> delivery;

  PaymentMethods({required this.delivery, required this.pickUp});

  factory PaymentMethods.fromJson(Map<String, dynamic> json) {
    try {
      return PaymentMethods(
          pickUp: (json["pickup"] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
          delivery: (json["delivery"] as List<dynamic>)
              .map((e) => e.toString())
              .toList());
    } catch (e) {
      print(e.toString() + 'region141');
      return PaymentMethods(delivery: [], pickUp: []);
    }
  }
}

class Promos {
  Promos({
    this.promo1,
    this.promo2,
    this.promo3,
  });

  Promo? promo1;
  Promo? promo2;
  Promo? promo3;

  factory Promos.fromJson(Map<String, dynamic> json) => Promos(
        promo1: Promo.fromJson(json["promo1"]),
        promo2: Promo.fromJson(json["promo2"]),
        promo3: Promo.fromJson(json["promo3"]),
      );
}

class Promo {
  Promo({
    required this.title,
    required this.text,
    required this.image,
  });

  final String title;
  final String text;
  final String image;

  factory Promo.fromJson(Map<String, dynamic> json) => Promo(
        title: json["title"],
        text: json["text"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "text": text,
        "image": image,
      };
}

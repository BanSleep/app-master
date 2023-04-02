// To parse this JSON data, do
//
//     final orderRequest = orderRequestFromJson(jsonString);

import 'dart:convert';

OrderRequest orderRequestFromJson(String str) =>
    OrderRequest.fromJson(json.decode(str));

//String orderRequestToJson(OrderRequest data) => json.encode(data.toJson());

class OrderRequest {
  OrderRequest(
      {required this.name,
      required this.phone,
      required this.products,
      this.mail,
      this.delivery,
      this.deliveryName,
      this.deliveryPhone,
      this.deliveryDate,
      this.deliveryAddressKilometers,
      this.deliveryPrice,
      this.deliveryAddress,
      this.deliveryAddressAdditional,
      this.exactTime,
      this.deliveryExactTime,
      this.deliveryTimeRange,
      this.deliveryShop,
      this.comment,
      this.doNotCall,
      this.postcardText,
      this.sms,
      this.promoCode,
      this.clientId});

  String name;
  String phone;
  String? mail;
  bool? delivery;
  String? deliveryName;
  String? deliveryPhone;
  String? deliveryDate;
  int? deliveryAddressKilometers;
  int? deliveryPrice;
  int? useBonus;
  String? deliveryAddress;
  String? deliveryAddressAdditional;
  bool? exactTime;
  String? deliveryExactTime;
  String? deliveryTimeRange;
  int? deliveryShop;
  String? comment;
  String? paymentMethod;
  bool? doNotCall;
  String? postcardText;
  bool? sms;
  String? promoCode;
  List<NewOrderProduct> products;
  String? clientId;

  factory OrderRequest.fromJson(Map<String, dynamic> json) => OrderRequest(
        name: json["name"],
        phone: json["phone"],
        mail: json["mail"],
        delivery: json["delivery"],
        deliveryName: json["delivery_name"],
        deliveryPhone: json["delivery_phone"],
        deliveryDate: json["delivery_date"],
        deliveryAddressKilometers: json["delivery_address_kilometers"],
        deliveryPrice: json["delivery_price"],
        deliveryAddress: json["delivery_address"],
        deliveryAddressAdditional: json["delivery_address_additional"],
        exactTime: json["exact_time"],
        deliveryExactTime: json["delivery_exact_time"],
        deliveryTimeRange: json["delivery_time_range"],
        deliveryShop: json["delivery_shop"],
        comment: json["comment"],
        doNotCall: json["do_not_call"],
        postcardText: json["postcard_text"],
        sms: json["sms"],
        clientId: json["clientId"],
        promoCode: json["promoCode"],
        products: List<NewOrderProduct>.from(
            json["products"].map((x) => NewOrderProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "mail": mail,
        "delivery": delivery,
        "delivery_name": deliveryName,
        "delivery_phone": deliveryPhone,
        "delivery_date": deliveryDate,
        "delivery_address_kilometers": deliveryAddressKilometers,
        "delivery_price": deliveryPrice,
        "delivery_address": deliveryAddress,
        "delivery_address_additional": deliveryAddressAdditional,
        "exact_time": exactTime,

        "delivery_exact_time": deliveryExactTime,
        "delivery_time_range": deliveryTimeRange,
        "delivery_shop": deliveryShop,
        "comment": comment,
        "do_not_call": doNotCall,
        "postcard_text": postcardText,
        "sms": sms,
    "payment_method":paymentMethod,
        "client_id": clientId,
        "promocode": promoCode,
        "use_bonus": useBonus,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class NewOrderProduct {
  NewOrderProduct({
    required this.productId,
    required this.number,
    required this.price,
    this.versionId,
    this.options,
  });

  int productId;
  int? versionId;
  int number;
  int price;
  List<OrderOption>? options;

  factory NewOrderProduct.fromJson(Map<String, dynamic> json) =>
      NewOrderProduct(
        productId: json["product_id"],
        versionId: json["version_id"],
        number: json["number"],
        price: json["price"],
        options: List<OrderOption>.from(
            json["options"].map((x) => OrderOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "version_id": versionId,
        "number": number,
        "price": price,
        "options": (options != null)
            ? List<dynamic>.from(options!.map((x) => x.toJson()))
            : null,
      };
}

class OrderOption {
  OrderOption({
    required this.id,
    required this.name,
    required this.price,
  });

  int id;
  String name;
  int price;

  factory OrderOption.fromJson(Map<String, dynamic> json) => OrderOption(
        id: json["id"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
      };
}

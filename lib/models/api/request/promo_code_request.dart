import 'dart:convert';

PromoCodeRequest promoCodeRequestFromJson(String str) =>
    PromoCodeRequest.fromJson(json.decode(str));

String promoCodeRequestToJson(PromoCodeRequest data) =>
    json.encode(data.toJson());

class PromoCodeRequest {
  PromoCodeRequest({
    required this.promoCode,
  });

  final String promoCode;

  factory PromoCodeRequest.fromJson(Map<String, dynamic> json) =>
      PromoCodeRequest(
        promoCode: json["promocode"],
      );

  Map<String, dynamic> toJson() => {
        "promocode": promoCode,
      };
}

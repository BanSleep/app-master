import 'dart:convert';

import 'package:cvetovik/models/api/response/base/app_base_response.dart';

enum PromoCodeType { order, catalogs, products_rubles, products_percent }

PromoCodeResponse promoCodeResponseFromJson(String str) =>
    PromoCodeResponse.fromJson(json.decode(str));

String promoCodeResponseToJson(PromoCodeResponse data) =>
    json.encode(data.toJson());

class PromoCodeResponse extends AppBaseResponse {
  PromoCodeResponse({required result, this.data, this.errors}) : super(result);

  PromoCodeData? data;
  List<String>? errors;

  factory PromoCodeResponse.fromJson(Map<String, dynamic> json) =>
      PromoCodeResponse(
          result: json["result"],
          data: json["data"] != null
              ? PromoCodeData.fromJson(json["data"])
              : null,
          errors: json["errors"] != null
              ? List<String>.from(json["errors"].map((x) => x))
              : null);

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": data != null ? data!.toJson() : null,
      };
}

class PromoCodeData {
  PromoCodeData({
    required this.promoCode,
    required this.description,
    required this.type,
    required this.catalogsList,
    this.minimumSum,
    this.discount,
  });

  final String? minimumSum;
  final String? discount;
  final String promoCode;
  final String description;
  final String type;
  Map<String, String>? catalogsList;

  factory PromoCodeData.fromJson(Map<String, dynamic> json) => PromoCodeData(
        promoCode: json["promocode"],
        description: json["description"],
        type: json["type"],
        minimumSum: (json["minimum_sum"] != null) ? json["minimum_sum"] : null,
        discount: (json["discount"] != null) ? json["discount"] : null,
        catalogsList: (json["catalogs_list"] != null)
            ? Map.from(json["catalogs_list"])
                .map((k, v) => MapEntry<String, String>(k, v))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "promocode": promoCode,
        "description": description,
        "type": type,
        "catalogs_list": catalogsList != null
            ? Map.from(catalogsList!)
                .map((k, v) => MapEntry<String, dynamic>(k, v))
            : null,
      };
}

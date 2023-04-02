import 'dart:convert';

import 'package:cvetovik/models/api/response/base/app_base_response.dart';

PaymentWidgetResponse paymentWidgetResponseFromJson(String str) =>
    PaymentWidgetResponse.fromJson(json.decode(str));

String paymentWidgetResponseToJson(PaymentWidgetResponse data) =>
    json.encode(data.toJson());

class PaymentWidgetResponse extends AppBaseResponse {
  PaymentWidgetResponse({
    result,
    this.data,
  }) : super(result);

  PaymentWidgetData? data;

  factory PaymentWidgetResponse.fromJson(Map<String, dynamic> json) =>
      PaymentWidgetResponse(
          result: json["result"],
          data: json["data"] != null
              ? PaymentWidgetData.fromJson(json["data"])
              : null);

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": (data != null) ? data!.toJson() : null,
      };
}

class PaymentWidgetData {
  PaymentWidgetData({
    required this.widget,
  });

  String widget;

  factory PaymentWidgetData.fromJson(Map<String, dynamic> json) =>
      PaymentWidgetData(
        widget: json["widget"],
      );

  Map<String, dynamic> toJson() => {
        "widget": widget,
      };
}

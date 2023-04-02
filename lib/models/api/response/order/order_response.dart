import 'dart:convert';

import 'package:cvetovik/models/api/response/base/app_base_response.dart';

OrderResponse orderResponseFromJson(String str) =>
    OrderResponse.fromJson(json.decode(str));

//String orderResponseToJson(OrderResponse data) => json.encode(data.toJson());

class OrderResponse extends AppBaseResponse {
  OrderResponse({
    required result,
    this.data,
  }) : super(result);

  OrderData? data;

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        result: json["result"],
        data: json["data"] != null ? OrderData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": data != null ? data!.toJson() : null,
      };
}

class OrderData {
  OrderData({
    required this.orderId,
  });

  int orderId;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        orderId: json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
      };
}

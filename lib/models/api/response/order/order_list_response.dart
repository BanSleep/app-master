import 'package:cvetovik/core/helpers/json_convertors.dart';
import 'package:cvetovik/models/api/response/base/app_base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_list_response.g.dart';

class OrderListResponse extends AppBaseResponse {
  OrderListResponse({
    required result,
    this.data,
  }) : super(result);

  List<Order>? data;

  factory OrderListResponse.fromJson(Map<String, dynamic> json) =>
      OrderListResponse(
        result: json["result"],
        data: json["data"] != null ? Order.fromJsonToList(json["data"]) : null,
      );
}

@JsonSerializable()
class Order {
  const Order({
    required this.id,
    required this.hexStatusColor,
    required this.time,
    required this.productsCount,
    required this.status,
    required this.statusName,
    required this.paymentAmount,
  });

  final int id;
  @JsonKey(name: "status_color")
  final String hexStatusColor;
  final String time;
  @JsonKey(name: 'products_count')
  final int productsCount;
  @IntFromStringConverter()
  final int status;
  @JsonKey(name: 'status_name')
  final String statusName;
  @JsonKey(name: 'payment_amount')
  @IntFromStringConverter()
  final int paymentAmount;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  static List<Order> fromJsonToList(json) {
    if (json is Map) json = json.values;
    return json.map((e) => Order.fromJson(e)).cast<Order>().toList();
  }
}

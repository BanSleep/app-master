import 'package:cvetovik/core/helpers/json_convertors.dart';
import 'package:cvetovik/models/api/response/base/app_base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_view_response.g.dart';

class OrderDetailsResponse extends AppBaseResponse {
  OrderDetailsResponse({
    required result,
    this.data,
  }) : super(result);

  OrderDetails? data;

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) =>
      OrderDetailsResponse(
        result: json["result"],
        data: json["data"] != null ? OrderDetails.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": data != null ? data!.toJson() : null,
      };
}

@JsonSerializable()
class OrderDetails {
  const OrderDetails({
    required this.id,
    required this.hexStatusColor,
    required this.time,
    required this.productsCount,
    required this.status,
    required this.statusName,
    required this.paymentAmount,
    required this.usedBonuses,
    required this.delivery,
    required this.products,
  });

  final int id;
  final String? time;
  @JsonKey(name: "status_color")
  final String hexStatusColor;
  @JsonKey(name: 'products_count')
  final int productsCount;
  @IntFromStringConverter()
  final int status;
  @JsonKey(name: 'status_name')
  final String statusName;
  @JsonKey(name: 'payment_amount')
  @IntFromStringConverter()
  final int paymentAmount;
  @JsonKey(name: 'used_bonuses')
  @IntFromStringConverter()
  final int usedBonuses;
  final OrderDelivery delivery;
  final List<OrderProduct> products;

  factory OrderDetails.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);
}

enum DeliveryType {
  @JsonValue("0")
  pickup,

  @JsonValue("1")
  delivery,
}

@JsonSerializable()
class OrderDelivery {
  const OrderDelivery({
    required this.type,
    required this.region,
    required this.address,
    required this.shopId,
    required this.exactTime,
    required this.date,
    required this.time,
    required this.price,
  });

  final DeliveryType type;
  @IntFromStringConverter()
  final int region;
  final String address;
  @JsonKey(name: 'shop_id')
  final int? shopId;
  @JsonKey(name: 'exact_time')
  final bool exactTime;
  final String date;
  final String time;
  final int price;

  factory OrderDelivery.fromJson(Map<String, dynamic> json) =>
      _$OrderDeliveryFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDeliveryToJson(this);
}

@JsonSerializable()
class OrderProduct {
  const OrderProduct({
    required this.productId,
    required this.versionId,
    required this.image,
    required this.sku,
    required this.name,
    required this.quantity,
    required this.totalCost,
    required this.totalBonus,
  });

  @JsonKey(name: 'product_id')
  @IntFromStringConverter()
  final int productId;
  @JsonKey(name: 'version_id')
  @IntFromStringConverter()
  final int versionId;
  final String? image;
  final String sku;
  final String name;
  @IntFromStringConverter()
  final int quantity;
  @JsonKey(name: 'total_cost')
  final int totalCost;
  @JsonKey(name: 'total_bonus')
  final int totalBonus;

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductToJson(this);
}

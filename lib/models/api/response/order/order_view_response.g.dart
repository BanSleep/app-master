// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_view_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) => OrderDetails(
      id: json['id'] as int,
      hexStatusColor: json['status_color'] as String,
      time: json['time'] as String?,
      productsCount: json['products_count'] as int,
      status: const IntFromStringConverter().fromJson(json['status'] as String),
      statusName: json['status_name'] as String,
      paymentAmount: const IntFromStringConverter()
          .fromJson(json['payment_amount'] as String),
      usedBonuses: const IntFromStringConverter()
          .fromJson(json['used_bonuses'] as String),
      delivery:
          OrderDelivery.fromJson(json['delivery'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>)
          .map((e) => OrderProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDetailsToJson(OrderDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'status_color': instance.hexStatusColor,
      'products_count': instance.productsCount,
      'status': const IntFromStringConverter().toJson(instance.status),
      'status_name': instance.statusName,
      'payment_amount':
          const IntFromStringConverter().toJson(instance.paymentAmount),
      'used_bonuses':
          const IntFromStringConverter().toJson(instance.usedBonuses),
      'delivery': instance.delivery,
      'products': instance.products,
    };

OrderDelivery _$OrderDeliveryFromJson(Map<String, dynamic> json) =>
    OrderDelivery(
      type: $enumDecode(_$DeliveryTypeEnumMap, json['type']),
      region: const IntFromStringConverter().fromJson(json['region'] as String),
      address: json['address'] as String,
      shopId: json['shop_id'] as int?,
      exactTime: json['exact_time'] as bool,
      date: json['date'] as String,
      time: json['time'] as String,
      price: json['price'] as int,
    );

Map<String, dynamic> _$OrderDeliveryToJson(OrderDelivery instance) =>
    <String, dynamic>{
      'type': _$DeliveryTypeEnumMap[instance.type]!,
      'region': const IntFromStringConverter().toJson(instance.region),
      'address': instance.address,
      'shop_id': instance.shopId,
      'exact_time': instance.exactTime,
      'date': instance.date,
      'time': instance.time,
      'price': instance.price,
    };

const _$DeliveryTypeEnumMap = {
  DeliveryType.pickup: '0',
  DeliveryType.delivery: '1',
};

OrderProduct _$OrderProductFromJson(Map<String, dynamic> json) => OrderProduct(
      productId:
          const IntFromStringConverter().fromJson(json['product_id'] as String),
      versionId:
          const IntFromStringConverter().fromJson(json['version_id'] as String),
      image: json['image'] as String?,
      sku: json['sku'] as String,
      name: json['name'] as String,
      quantity:
          const IntFromStringConverter().fromJson(json['quantity'] as String),
      totalCost: json['total_cost'] as int,
      totalBonus: json['total_bonus'] as int,
    );

Map<String, dynamic> _$OrderProductToJson(OrderProduct instance) =>
    <String, dynamic>{
      'product_id': const IntFromStringConverter().toJson(instance.productId),
      'version_id': const IntFromStringConverter().toJson(instance.versionId),
      'image': instance.image,
      'sku': instance.sku,
      'name': instance.name,
      'quantity': const IntFromStringConverter().toJson(instance.quantity),
      'total_cost': instance.totalCost,
      'total_bonus': instance.totalBonus,
    };

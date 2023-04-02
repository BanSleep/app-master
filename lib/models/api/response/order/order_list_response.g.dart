// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as int,
      hexStatusColor: json['status_color'] as String,
      time: json['time'] as String,
      productsCount: json['products_count'] as int,
      status: const IntFromStringConverter().fromJson(json['status'] as String),
      statusName: json['status_name'] as String,
      paymentAmount: const IntFromStringConverter()
          .fromJson(json['payment_amount'] as String),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'status_color': instance.hexStatusColor,
      'time': instance.time,
      'products_count': instance.productsCount,
      'status': const IntFromStringConverter().toJson(instance.status),
      'status_name': instance.statusName,
      'payment_amount':
          const IntFromStringConverter().toJson(instance.paymentAmount),
    };

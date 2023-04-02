// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_address_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditFavoriteAddressRequest _$EditFavoriteAddressRequestFromJson(
        Map<String, dynamic> json) =>
    EditFavoriteAddressRequest(
      title: json['title'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      addressAdditional: json['address_additional'] as String,
    );

Map<String, dynamic> _$EditFavoriteAddressRequestToJson(
        EditFavoriteAddressRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'address_additional': instance.addressAdditional,
    };

AddFavoriteAddressRequest _$AddFavoriteAddressRequestFromJson(
        Map<String, dynamic> json) =>
    AddFavoriteAddressRequest(
      regionId:
          const IntFromStringConverter().fromJson(json['region_id'] as String),
      title: json['title'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      addressAdditional: json['address_additional'] as String,
    );

Map<String, dynamic> _$AddFavoriteAddressRequestToJson(
        AddFavoriteAddressRequest instance) =>
    <String, dynamic>{
      'region_id': const IntFromStringConverter().toJson(instance.regionId),
      'title': instance.title,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'address_additional': instance.addressAdditional,
    };

FavoriteAddress _$FavoriteAddressFromJson(Map<String, dynamic> json) =>
    FavoriteAddress(
      id: json['id'] as int,
      regionId:
          const IntFromStringConverter().fromJson(json['region_id'] as String),
      title: json['title'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      addressAdditional: json['address_additional'] as String,
    );

Map<String, dynamic> _$FavoriteAddressToJson(FavoriteAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'region_id': const IntFromStringConverter().toJson(instance.regionId),
      'title': instance.title,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'address_additional': instance.addressAdditional,
    };

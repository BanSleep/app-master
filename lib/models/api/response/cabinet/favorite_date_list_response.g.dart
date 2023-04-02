// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_date_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddFavoriteDateRequest _$AddFavoriteDateRequestFromJson(
        Map<String, dynamic> json) =>
    AddFavoriteDateRequest(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      day: const IntFromStringConverter().fromJson(json['day'] as String),
      month: const IntFromStringConverter().fromJson(json['month'] as String),
    );

Map<String, dynamic> _$AddFavoriteDateRequestToJson(
        AddFavoriteDateRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'day': const IntFromStringConverter().toJson(instance.day),
      'month': const IntFromStringConverter().toJson(instance.month),
    };

EditFavoriteDateRequest _$EditFavoriteDateRequestFromJson(
        Map<String, dynamic> json) =>
    EditFavoriteDateRequest(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      day: const IntFromStringConverter().fromJson(json['day'] as String),
      month: const IntFromStringConverter().fromJson(json['month'] as String),
    );

Map<String, dynamic> _$EditFavoriteDateRequestToJson(
        EditFavoriteDateRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'day': const IntFromStringConverter().toJson(instance.day),
      'month': const IntFromStringConverter().toJson(instance.month),
    };

FavoriteDate _$FavoriteDateFromJson(Map<String, dynamic> json) => FavoriteDate(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      day: const IntFromStringConverter().fromJson(json['day'] as String),
      month: const IntFromStringConverter().fromJson(json['month'] as String),
    );

Map<String, dynamic> _$FavoriteDateToJson(FavoriteDate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'day': const IntFromStringConverter().toJson(instance.day),
      'month': const IntFromStringConverter().toJson(instance.month),
    };

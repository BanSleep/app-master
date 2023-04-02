import 'package:cvetovik/models/api/response/base/app_base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cvetovik/core/helpers/json_convertors.dart';

part 'favorite_date_list_response.g.dart';

class FavoriteDateListResponse extends AppBaseResponse {
  FavoriteDateListResponse({
    required result,
    this.data,
  }) : super(result);

  List<FavoriteDate>? data;

  factory FavoriteDateListResponse.fromJson(json) => FavoriteDateListResponse(
        result: json["result"],
        data: json["data"] != null
            ? FavoriteDate.fromJsonToList(json["data"])
            : null,
      );
}

@JsonSerializable()
class AddFavoriteDateRequest {
  const AddFavoriteDateRequest({
    required this.title,
    required this.subtitle,
    required this.day,
    required this.month,
  });

  final String title;
  final String subtitle;
  @IntFromStringConverter()
  final int day;
  @IntFromStringConverter()
  final int month;

  factory AddFavoriteDateRequest.fromJson(json) =>
      _$AddFavoriteDateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddFavoriteDateRequestToJson(this);
}

@JsonSerializable()
class EditFavoriteDateRequest {
  const EditFavoriteDateRequest({
    required this.title,
    required this.subtitle,
    required this.day,
    required this.month,
  });

  final String title;
  final String subtitle;
  @IntFromStringConverter()
  final int day;
  @IntFromStringConverter()
  final int month;

  factory EditFavoriteDateRequest.fromJson(json) =>
      _$EditFavoriteDateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EditFavoriteDateRequestToJson(this);
}

@JsonSerializable()
class FavoriteDate {
  const FavoriteDate({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.day,
    required this.month,
  });

  final int id;
  final String title;
  final String subtitle;
  @IntFromStringConverter()
  final int day;
  @IntFromStringConverter()
  final int month;

  factory FavoriteDate.fromJson(json) => _$FavoriteDateFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteDateToJson(this);

  static List<FavoriteDate> fromJsonToList(json) {
    if (json is Map) json = json.values;
    return json
        .map((e) => FavoriteDate.fromJson(e))
        .cast<FavoriteDate>()
        .toList();
  }
}

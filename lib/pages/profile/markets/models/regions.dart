import 'package:cvetovik/models/api/response/base/app_base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cvetovik/core/helpers/json_convertors.dart';

part 'regions.g.dart';

@JsonSerializable()
class RegionModel {
  const RegionModel({
    required this.id,
    required this.title,
    required this.areaTitle,

  });

  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '',name: 'area_title')
  final String areaTitle;


  factory RegionModel.fromJson(json) => _$RegionModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegionModelToJson(this);

  static List<RegionModel> fromJsonToList(json) {
    if (json is Map) json = json.values;
    return json
        .map((e) => RegionModel.fromJson(e))
        .cast<RegionModel>()
        .toList();
  }
}

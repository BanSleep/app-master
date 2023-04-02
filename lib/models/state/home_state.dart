import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initializing() = _Initializing;
  const factory HomeState.loaded(RegionResponse data) = _Loaded;
  const factory HomeState.error(String? text) = _Error;
}

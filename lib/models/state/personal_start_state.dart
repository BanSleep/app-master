import 'package:cvetovik/models/api/response/cabinet/client_info_response.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_start_state.freezed.dart';

@freezed
class PersonalStartState with _$PersonalStartState {
  const factory PersonalStartState.initializing() = _Initializing;
  const factory PersonalStartState.loaded(
      RegionResponse data, ClientInfoResponse info) = _Loaded;
  const factory PersonalStartState.error(String? text) = _Error;
}

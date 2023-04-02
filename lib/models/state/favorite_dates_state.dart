import 'package:cvetovik/models/api/response/cabinet/favorite_date_list_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_dates_state.freezed.dart';

@freezed
class FavoriteDatesState with _$FavoriteDatesState {
  const factory FavoriteDatesState.initializing() = _Initializing;
  const factory FavoriteDatesState.loaded(List<FavoriteDate> data) = _Loaded;
  const factory FavoriteDatesState.emptyData() = _EmptyData;
  const factory FavoriteDatesState.error(String? text) = _Error;
}

import 'package:cvetovik/models/api/response/order/order_list_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_date_view_state.freezed.dart';

@freezed
class FavoriteDateView with _$FavoriteDateView {
  const factory FavoriteDateView.initializing() = _Initializing;
  const factory FavoriteDateView.loaded(List<Order> data) = _Loaded;
  const factory FavoriteDateView.emptyData() = _EmptyData;
  const factory FavoriteDateView.error(String? text) = _Error;
}

import 'package:cvetovik/models/api/response/order/order_view_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_view_state.freezed.dart';

@freezed
class OrderViewState with _$OrderViewState {
  const factory OrderViewState.initializing() = _Initializing;
  const factory OrderViewState.loaded(OrderDetails data) = _Loaded;
  const factory OrderViewState.error(String? text) = _Error;
}

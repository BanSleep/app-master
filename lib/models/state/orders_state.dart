import 'package:cvetovik/models/api/response/order/order_list_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'orders_state.freezed.dart';

@freezed
class OrdersState with _$OrdersState {
  const factory OrdersState.initializing() = _Initializing;
  const factory OrdersState.loaded(List<Order> data) = _Loaded;
  const factory OrdersState.emptyData() = _EmptyData;
  const factory OrdersState.error(String? text) = _Error;
}

import 'package:cvetovik/pages/cart/models/cart_price_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_content_state.freezed.dart';

@freezed
class CartContentState with _$CartContentState {
  const factory CartContentState.initializing() = _Initializing;
  const factory CartContentState.loaded(CartPriceData data) = _Loaded;
  const factory CartContentState.checkedPromoCode(CartPriceData data) =
      _CheckedPromoCode;
  //const factory CartContentState.error(String? text) = _Error;
}

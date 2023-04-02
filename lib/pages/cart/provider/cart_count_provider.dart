import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartCountProvider = StateProvider<CartCountData>((ref) {
  return CartCountData();
});

class CartCountData {
  CartCountData({this.count = 0});
  final int count;
}

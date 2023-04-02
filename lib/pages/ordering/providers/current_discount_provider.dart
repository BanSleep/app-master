import 'package:cvetovik/pages/ordering/models/discount/discount_data.dart';
import 'package:riverpod/riverpod.dart';

final discountProvider = StateProvider<DiscountData>((ref) {
  return DiscountData();
});

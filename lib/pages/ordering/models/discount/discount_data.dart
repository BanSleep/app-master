import 'package:cvetovik/pages/ordering/models/discount/discount_item.dart';

class DiscountData {
  final String promoCode;
  final List<DiscountItem> items;

  DiscountData({this.promoCode = '', this.items = const []});

  bool check() {
    return promoCode.isNotEmpty && items.isNotEmpty;
  }
}

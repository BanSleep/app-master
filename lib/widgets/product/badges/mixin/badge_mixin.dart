import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/pages/products/models/enum/product_badges.dart';

mixin BadgeMixin {
  String getTitle({required ProductBadges badge, bool isSmall = true}) {
    late String res;
    switch (badge) {
      case ProductBadges.hour:
        res = AppRes.oneHour;
        break;
      case ProductBadges.hot:
        res = AppRes.hot;
        break;
      case ProductBadges.newItem:
        res = AppRes.newItem;
        break;
      case ProductBadges.promo1:
        res = AppRes.stock;
        break;
      case ProductBadges.promo2:
        res = AppRes.stock2;
        break;
      case ProductBadges.promo3:
        res = AppRes.stock3;
        break;
      case ProductBadges.bprice:
        res = AppRes.bprice;
        break;
      case ProductBadges.cashback:
        res = AppRes.cashback;
        break;
    }
    if (isSmall) {
      return res.toLowerCase();
    } else
      return res;
  }
}

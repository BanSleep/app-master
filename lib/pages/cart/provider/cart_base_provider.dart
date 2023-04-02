import 'package:collection/collection.dart';
import 'package:cvetovik/models/api/response/product_card_response.dart';

class CartBaseProvider {
  ProductCardPrice? getProductPriceFromSource(
      List<Version>? versions, String? versionTitle, int count) {
    if (versions != null && versionTitle != null) {
      if (versionTitle.isNotEmpty) {
        var version = versions
            .firstWhereOrNull((element) => element.title == versionTitle);
        if (version != null) {
          var currPrice =
              version.prices.lastWhere((element) => element.minNum <= count);
          return currPrice;
        }
      } else {
        var version = versions.first;
        var currPrice =
            version.prices.lastWhere((element) => element.minNum <= count);
        return currPrice;
      }
    }
    return null;
  }
}

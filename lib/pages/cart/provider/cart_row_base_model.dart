import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:cvetovik/pages/cart/models/row_provider_data.dart';

import 'cart_base_provider.dart';

class CartRowBaseModel extends CartBaseProvider {
  late int price;
  late int count;

  final RowProviderData data;

  CartRowBaseModel(this.data) {
    count = data.main.count;
  }

  void _updatePrice() {
    var currPrice = _getProductPrice();
    if (currPrice != null) {
      price = currPrice.price;
    } else {
      price = data.main.price;
    }
  }

  ProductCardPrice? _getProductPrice() {
    var price = getProductPriceFromSource(
        data.main.versions, data.main.versionTitle, count);
    return price;
  }

  int getSum() {
    _updatePrice();
    var addSum = _getAddSum();
    var mainSum = _getMainSum();
    var res = addSum + mainSum;
    print(res);
    return res;
  }

  int _getAddSum() {
    int addSum = 0;
    if (data.add != null) {
      data.add!.forEach((element) {
        addSum = addSum + element.price;
      });
    }
    return addSum;
  }

  int _getMainSum() {
    return count * price;
  }
}

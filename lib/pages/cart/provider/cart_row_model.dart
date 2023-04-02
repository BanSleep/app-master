import 'package:cvetovik/core/db/dao/cart_dao.dart';
import 'package:cvetovik/pages/cart/models/row_provider_data.dart';
import 'package:cvetovik/pages/cart/provider/cart_row_base_model.dart';

class CartRowModel extends CartRowBaseModel {
  final CartDao cartDao;

  CartRowModel(RowProviderData data, this.cartDao) : super(data);

  Future<int> incCount() async {
    count++;
    await cartDao.updateProduct(curr: data.main, count: count);
    var res = getSum();
    return res;
  }

  Future<int> decCount() async {
    if (count > 1) {
      count--;
      await cartDao.updateProduct(curr: data.main, count: count);
      var res = getSum();
      return res;
    } else
      return 0;
  }

  Future<void> deleteProduct() async {
    await cartDao.deleteProduct(data.main.productId);
  }
}

import 'package:collection/collection.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/db/dao/cart_dao.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/services/providers/linked_data_provider.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/request/order_request.dart';
import 'package:cvetovik/models/api/response/linked/linked_decors_response.dart';
import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/provider/product_cart_title.dart';
import 'package:cvetovik/pages/cart/models/row_provider_data.dart';
import 'package:cvetovik/pages/cart/provider/cart_base_provider.dart';
import 'package:cvetovik/pages/cart/provider/cart_row_base_model.dart';
import 'package:cvetovik/pages/products/models/cart_sheet_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartTitleProvider =
    StateProvider<ProductCartTitle>((ref) => ProductCartTitle());

final productCartProvider = Provider<ProductCartProvider>((ref) {
  var set = ref.read(settingsProvider);
  var linked = ref.read(linkedDataProvider);
  var cartDao = ref.read(cartDaoProvider);
  return ProductCartProvider(set, linked, ref, cartDao);
});

class ProductCartProvider extends CartBaseProvider {
  //region init
  final SettingsService _set;
  final CartDao cartDao;
  int _catalogId = 0;
  bool _isFirst = true;
  int _count = 0;
  final LinkedDataProvider _linked;
  List<DecorProduct> _selectedItems = [];
  final ProviderRef _ref;
  late ProductData _product;
  late int _price;
  late List<CartAddData>? _prevAddSelected;
  List<DecorProduct> get selectedItems => _selectedItems;
  late int currentPrice;

  ProductCartProvider(this._set, this._linked, this._ref, this.cartDao);

  ProductData get product => _product;

  void init(int catalogId, ProductData product, int price) {
    _catalogId = catalogId;
    _selectedItems = [];
    _product = product;
    _prevAddSelected = [];
    _isFirst = true;
    _price = price;
  }

  Future<CartSheetData> prepareShowAddProductToCartSheet(
      BuildContext context, ProductData item, int price, int catalogId) async {
    //var catalogId = _ref.read(catalogIdProvider);
    init(catalogId, item, price);

    var linkedDecors = await getLinkedDecor();
    var addProducts = await getAddItemsById(item.id);
    if (addProducts != null) {
      _selectedItems = addProducts
          .map((e) => DecorProduct(
              id: e.productId, image: e.image, title: e.title, price: e.price))
          .toList();
    }

    _count = await getCountProductCartById(item.id);
    var curr = await cartDao.getProductCartById(item.id);
    int currPrice = 0;
    if (curr != null) {
      var model = CartRowBaseModel(RowProviderData(curr, addProducts));
      currPrice = model.getSum();
      currentPrice = currPrice;
      print("Current price: $currPrice");
    }
    var cartTitle = _ref.read(cartTitleProvider.notifier);
    cartTitle.state =
        cartTitle.state.copyWith(count: (_count > 0) ? _count : 1);
    updateTitle();
    return CartSheetData(addProducts, linkedDecors, currPrice);
  }
  //endregion

  //region DB
  Future<List<CartAddData>?> getAddItemsById(int productId) async {
    _prevAddSelected = await cartDao.getAddItemsById(productId);
    return _prevAddSelected;
  }

  Future<int> getCountProductCartById(int productId) async {
    var curr = await cartDao.getProductCartById(productId);
    return (curr != null) ? curr.count : 0;
  }

  Future<List<NewOrderProduct>> getProductsForOrder() async {
    var items = await cartDao.getItems();
    if (items.isNotEmpty) {
      List<NewOrderProduct> res = [];
      var addItems = await cartDao.getAddItems();
      items.forEach((el) {
        var versionId = getVersionId(el.versions, el.versionTitle);
        var versionPrice =
            getProductPriceFromSource(el.versions, el.versionTitle, el.count);
        var currPrice = (versionPrice != null) ? versionPrice.price : el.price;
        var newOrderProduct = NewOrderProduct(
            number: el.count,
            price: currPrice,
            productId: el.productId,
            versionId: versionId);
        if (addItems != null) {
          List<CartAddData> currAdd =
              addItems.where((t) => t.mainId == el.id).toList();
          if (currAdd.isNotEmpty) {
            var options = currAdd
                .map((e) => OrderOption(
                      name: e.title,
                      id: e.productId,
                      price: e.price,
                    ))
                .toList();
            newOrderProduct.options = options;
          }
        }
        res.add(newOrderProduct);
      });
      return res;
    } else {
      return [];
    }
  }

  Future<List<NewOrderProduct>> getProductForOrder(int id) async {
    List<NewOrderProduct> products = [];
    var count = _getCount();
    var state = _ref.read(cartTitleProvider.notifier).state;
    var versionTitle = state.versionTitle;
    var versions = state.versions;
    _getPriceValue();
    var versionId = getVersionId(versions, versionTitle);
    var tmpAdd = await getAddItemsById(id);
    List<OrderOption>? options;
    if (tmpAdd != null && tmpAdd.length > 0) {
      options = tmpAdd
          .map((e) =>
              OrderOption(name: e.title, id: e.productId, price: e.price))
          .toList();
    }
    products.add(NewOrderProduct(
        number: count,
        price: _price,
        productId: id,
        versionId: versionId,
        options: options));
    return products;
  }

  int getVersionId(List<Version>? versions, String? versionTitle) {
    if (versions != null && versionTitle != null) {
      var version =
          versions.firstWhereOrNull((element) => element.title == versionTitle);
      if (version != null && version.id != null) {
        return version.id!;
      }
    }
    return 0;
  }

  Future<void> addToCart() async {
    var count = _getCount();
    var state = _ref.read(cartTitleProvider.notifier).state;
    var versionTitle = state.versionTitle;
    var versions = state.versions;
    await cartDao.insertProduct(
        data: product,
        count: count,
        catalogId: _catalogId,
        versionTitle: versionTitle,
        versions: versions);
    await cartDao.insertAddProducts(selectedItems, product.id, isExist());
  }
  //endregion

  //region Decor
  Future<Map<String, LinkedDecor>?> getLinkedDecor() async {
    var regData = _set.getDeviceRegisterWithRegion();
    var linkedDecors = await _linked.getLinkedDecors(_catalogId, regData);
    return linkedDecors;
  }

  void updateDecor(bool selected, DecorProduct decor) {
    if (selected) {
      _addDecor(decor);
    } else {
      _removeDecor(decor);
    }

    updateTitle();
  }

  void _addDecor(DecorProduct decor) {
    DecorProduct? curr = _getCurrDecor(decor);
    if (curr == null) {
      _selectedItems.add(decor);
    }
  }

  void _removeDecor(DecorProduct decor) {
    DecorProduct? curr = _getCurrDecor(decor);
    if (curr != null) {
      var res = _selectedItems.remove(curr);
      print("Decor removed: $res");
    }
  }

  DecorProduct? _getCurrDecor(DecorProduct decor) {
    var curr = _selectedItems.firstWhereOrNull((el) => el.id == decor.id);
    return curr;
  }
  //endregion

  //region Calc

  bool isExist() {
    return (_count > 0);
  }

  int _getAddSum() {
    int sum = 0;
    _selectedItems.forEach((element) {
      sum = sum + element.price;
    });
    return sum;
  }

  int _getPrevAddSum() {
    int sum = 0;
    if (_prevAddSelected != null) {
      _prevAddSelected!.forEach((element) {
        sum = sum + element.price;
      });
    }
    return sum;
  }

  int _getMainSum() {
    var count = _getCount();
    var res = count * _price;
    return res;
  }

  int _getPrevMainSum() {
    return _count * _price;
  }

  int _getCount() => _ref.read(cartTitleProvider.notifier).state.count;

  int _getPrevSum() {
    var addPrevSum = _getPrevAddSum();
    var mainPrevSum = _getPrevMainSum();
    return addPrevSum + mainPrevSum;
  }

  //endregion

  //region Count
  void updateCountByNewValue(int value) {
    var cartTitle = _ref.read(cartTitleProvider.notifier);
    cartTitle.state = cartTitle.state.copyWith(count: value);
    updateTitle();
  }

  void updateCountByStep(bool add) {
    var cartTitle = _ref.read(cartTitleProvider.notifier);
    int count = cartTitle.state.count;
    if (add) {
      count = count + 1;
    } else {
      if (count > 1) {
        count = count - 1;
      }
    }

    int sum = _price * count;
    var mainTitle = '$sum ${AppRes.shortCurrency}';
    cartTitle.state =
        cartTitle.state.copyWith(count: count, mainTitle: mainTitle);
    updateTitle();
  }
  //endregion

  //region variant&price
  Version? getVersion({String title = ''}) {
    var cartTitle = _ref.read(cartTitleProvider.notifier);

    if (cartTitle.state.versions != null) {
      if (title.isEmpty) {
        return cartTitle.state.versions!.first;
      } else {
        return cartTitle.state.versions!
            .firstWhere((element) => element.title == title);
      }
    } else {
      return null;
    }
  }

  ProductCardPrice? getProductPrice() {
    var cartTitleState = _ref.read(cartTitleProvider.notifier).state;
    var versionTitle = cartTitleState.versionTitle;
    var count = cartTitleState.count;
    var versions = cartTitleState.versions;
    var price = getProductPriceFromSource(versions, versionTitle, count);
    return price;
  }

  void _getPriceValue() {
    var currPrice = getProductPrice();
    if (currPrice != null) {
      _price = currPrice.price;
    }
  }
  //endregion

  //region UpdateTitle
  void updateTitle({int prev = 0}) {
    _getPriceValue();
    var add = _getAddSum();
    var main = _getMainSum();
    print("Add sum: $add");
    print("Main sum: $main");
    int allSum = add + main;

    if (isExist() && !_isFirst) {
      int prevSum = 0;
      if (prev > 0) {
        prevSum = prev;
      } else {
        prevSum = _getPrevSum();
      }
      //allSum = allSum - prevSum;
    }
    print('all $allSum');
    var actionTitle =
        '${_getActionTitlePrefix()} $allSum ${AppRes.shortCurrency}';
    var cartTitle = _ref.read(cartTitleProvider.notifier);
    cartTitle.state = cartTitle.state.copyWith(
      actionTitle: actionTitle,
      mainTitle: "$main ${AppRes.shortCurrency}",
      addTitle: "$add ${AppRes.shortCurrency}",
    );
    if (_isFirst) {
      _isFirst = false;
    }
  }

  String _getActionTitlePrefix() {
    if (isExist()) {
      if (_isFirst)
        return AppRes.alreadyInCart;
      else {
        return AppRes.add;
      }
    } else
      return AppRes.add;
  }

  //endregion

}

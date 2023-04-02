import 'package:cvetovik/core/db/table/cart_add.dart';
import 'package:cvetovik/models/api/response/linked/linked_decors_response.dart';
import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:moor_flutter/moor_flutter.dart';

import '../app_database.dart';
import '../table/cart_main.dart';

part 'cart_dao.g.dart';

enum updateCountCartState { add, remove, clear }

@UseDao(
  tables: [CartMain, CartAdd],
)
class CartDao extends DatabaseAccessor<AppDatabase> with _$CartDaoMixin {
  //region Init
  CartDao(AppDatabase db, this.onUpdateCartCount, this.onInitCartCount)
      : super(db);

  final Function(updateCountCartState state) onUpdateCartCount;
  final Function(int count) onInitCartCount;
  //endregion

  //region Stream
  Stream<List<CartAddData>> streamAddItems() {
    return (select(cartAdd)..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .watch();
  }

  Stream<int?> streamItem() {
    return (select(cartMain)).map((e) => e.id).watchSingleOrNull();
  }

  Stream<List<CartMainData>> streamItems() {
    return (select(cartMain)..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .watch();
  }
  //endregion

  //region Get

  Future<List<CartMainData>> getItems() {
    return (select(cartMain)..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();
  }

  Future<int> getCartCount() async {
    var items = await (select(cartMain)..map((t) => t.id)).get();
    var count = items.length;
    onInitCartCount(count);
    return count;
  }

  Future<List<CartAddData>?> getAddItemsById(int productId) async {
    CartMainData? curr = await _getCurrProduct(productId);
    if (curr != null) {
      var res = await (select(cartAdd)
            ..where((t) => t.mainId.equals(curr.id))
            ..orderBy([(t) => OrderingTerm(expression: t.id)]))
          .get();
      return res;
    }
    return null;
  }

  Future<List<CartAddData>?> getAddItems() async {
    var res = await (select(cartAdd)
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();
    return res;
  }

  Future<CartMainData?> getProductCartById(int productId) async {
    var curr = await (select(cartMain)
          ..where((tbl) => tbl.productId.equals(productId)))
        .getSingleOrNull();
    return curr;
  }

  Future<CartMainData?> _getCurrProduct(int id) async {
    var curr = await (select(cartMain)
          ..where((tbl) => tbl.productId.equals(id)))
        .getSingleOrNull();
    return curr;
  }

  //endregion

  //region CRUD

  Future<int> insertProduct(
      {required ProductData data,
      required int count,
      required int catalogId,
      required String? versionTitle,
      List<Version>? versions}) async {
    CartMainData? curr = await _getCurrProduct(data.id);
    if (curr == null) {
      var item = CartMainCompanion(
          title: Value(data.title),
          productId: Value(data.id),
          price: Value(data.price),
          bonus: Value(data.bonus),
          count: Value(count),
          catalogId: Value(catalogId),
          image: Value(data.image),
          regularPrice: Value(data.regularPrice),
          versionTitle: Value(versionTitle),
          badges: Value(data.badges),
          versions: Value(versions));
      var id = await into(cartMain).insert(item);
      this.onUpdateCartCount(updateCountCartState.add);
      return id;
    } else {
      var updItem = curr.copyWith(versionTitle: versionTitle);
      await updateProduct(curr: updItem, count: count);
      return curr.id;
    }
  }

  Future<void> deleteAll() async {
    await batch((batch) async {
      var res = await delete(cartMain).go();
      print(res);
      res = await delete(cartAdd).go();
      print(res);
    });
    this.onUpdateCartCount(updateCountCartState.clear);
  }

  Future<void> updateStepCount(int id, int count) async {
    CartMainData? curr = await _getCurrProduct(id);
    if (curr != null) {
      await updateProduct(curr: curr, count: count);
    }
  }

  Future<void> updateProduct(
      {required CartMainData curr, int count = 1}) async {
    var newItem = CartMainData(
        id: curr.id,
        title: curr.title,
        productId: curr.productId,
        price: curr.price,
        bonus: curr.bonus,
        count: count,
        catalogId: curr.catalogId,
        image: curr.image,
        regularPrice: curr.regularPrice,
        badges: curr.badges,
        versions: curr.versions,
        versionTitle: curr.versionTitle);
    await update(cartMain).replace(newItem);
  }

  Future<void> deleteProduct(int id) async {
    CartMainData? curr = await _getCurrProduct(id);
    if (curr != null) {
      await _deleteAddById(curr.productId);
      var res = await delete(cartMain).delete(curr);
      print(res);
      this.onUpdateCartCount(updateCountCartState.remove);
    }
  }

  Future<void> insertAddProducts(List<DecorProduct> selectedItems,
      int mainProductId, bool isExists) async {
    CartMainData? curr = await _getCurrProduct(mainProductId);

    if (curr != null) {
      if (isExists) {
        await _deleteAddById(curr.productId);
      }
      if (selectedItems.isNotEmpty) {
        await batch((batch) {
          var items = selectedItems
              .map((e) => CartAddCompanion.insert(
                  productId: e.id,
                  mainId: curr.id,
                  title: e.title,
                  image: e.image,
                  price: e.price))
              .toList();
          batch.insertAll(cartAdd, items);
        });
      }
    }
  }

  Future<void> _deleteAddById(int productId) async {
    var add = await getAddItemsById(productId);
    if (add != null) {
      //TODO improve it
      //delete(cartAdd)..where((tbl) => t.).go();
      for (var item in add) {
        var res = await delete(cartAdd).delete(item);
        print(res);
      }
    }
  }

  //endregion
}

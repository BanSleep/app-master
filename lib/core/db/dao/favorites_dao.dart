import 'package:cvetovik/core/db/table/favorites.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:moor_flutter/moor_flutter.dart';

import '../app_database.dart';

part 'favorites_dao.g.dart';

@UseDao(
  tables: [Favorites],
)
class FavoritesDao extends DatabaseAccessor<AppDatabase>
    with _$FavoritesDaoMixin {
  FavoritesDao(AppDatabase db) : super(db);

  Stream<List<FavoriteData>> streamItems() {
    return (select(favorites)
          ..orderBy([(t) => OrderingTerm(expression: t.favoriteId)]))
        .watch();
  }

  Future<List<FavoriteData>?> getItemsForCart(List<int> ids) async {
    var res = await (select(favorites)..where((t) => t.id.isIn(ids))).get();
    return res;
  }

  Future<List<FavoriteData>?> getItems() async {
    var res = await (select(favorites)
          ..orderBy([(t) => OrderingTerm(expression: t.favoriteId)]))
        .get();
    return res;
  }

  Future<int> insertFav(ProductData data) async {
    var curr = await (select(favorites)..where((t) => t.id.equals(data.id)))
        .getSingleOrNull();
    if (curr != null) {
      return 0;
    }
    var fav = FavoritesCompanion(
      id: Value(data.id),
      image: Value(data.image),
      badges: Value(data.badges),
      bonus: Value(data.bonus),
      maxPrice: Value(data.maxPrice),
      price: Value(data.price),
      priceTime: Value(data.priceTime),
      regularPrice: Value(data.regularPrice),
      sku: Value(data.sku),
      title: Value(data.title),
      averageMark:
          (data.averageMark != null) ? Value(data.averageMark!) : Value(0),
    );

    var id = await into(favorites).insert(fav);
    return id;
  }

  Future<int> deleteFav(int id) async {
    var curr = await _getCurr(id);
    if (curr != null) {
      var res = await delete(favorites).delete(curr);
      return res;
    } else {
      return 0;
    }
  }

  Future<FavoriteData?> _getCurr(int id) async {
    var curr = await (select(favorites)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    return curr;
  }
}

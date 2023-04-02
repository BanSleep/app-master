import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/db/dao/address_dao.dart';
import 'package:cvetovik/core/db/dao/cart_dao.dart';
import 'package:cvetovik/core/db/dao/favorites_dao.dart';
import 'package:cvetovik/pages/cart/provider/cart_count_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dbProvider = Provider<AppDatabase>((ref) {
  var database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

final favoritesDaoProvider = Provider<FavoritesDao>((ref) {
  var db = ref.read(dbProvider);
  var dao = FavoritesDao(db);
  return dao;
});

final cartDaoProvider = Provider<CartDao>((ref) {
  onUpdateCount(updateCountCartState state) {
    var count = ref.read(cartCountProvider.notifier);
    switch (state) {
      case updateCountCartState.add:
        count.state = CartCountData(count: count.state.count + 1);
        break;
      case updateCountCartState.remove:
        count.state = CartCountData(count: count.state.count - 1);
        break;
      case updateCountCartState.clear:
        count.state = CartCountData();
        break;
    }
  }

  onInitCount(int value) {
    var count = ref.read(cartCountProvider.notifier);
    count.state = CartCountData(count: value);
  }

  var db = ref.read(dbProvider);
  var dao = CartDao(db, onUpdateCount, onInitCount);
  return dao;
});

final addressDaoProvider = Provider<AddressDao>((ref) {
  var db = ref.read(dbProvider);
  var dao = AddressDao(db);
  return dao;
});

final cartAddProvider = StreamProvider<List<CartAddData>>((ref) {
  var dao = ref.watch(cartDaoProvider);
  return dao.streamAddItems();
});

final cartStateProvider = StreamProvider<int?>((ref) {
  var dao = ref.watch(cartDaoProvider);
  var res = dao.streamItem();
  return res;
});

final cartListProvider = StreamProvider<List<CartMainData>>((ref) {
  var dao = ref.watch(cartDaoProvider);
  return dao.streamItems();
});

final addressListProvider = StreamProvider<List<AddressData>>((ref) {
  var dao = ref.watch(addressDaoProvider);
  return dao.streamItems();
});

final addressLastProvider = StreamProvider<List<AddressData>>((ref) {
  var dao = ref.watch(addressDaoProvider);
  return dao.streamLast();
});

final favoriteListProvider = StreamProvider<List<FavoriteData>>((ref) {
  var dao = ref.watch(favoritesDaoProvider);
  return dao.streamItems();
});

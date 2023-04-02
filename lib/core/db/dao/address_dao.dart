import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/db/table/addresses.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'address_dao.g.dart';

@UseDao(
  tables: [Addresses],
)
class AddressDao extends DatabaseAccessor<AppDatabase> with _$AddressDaoMixin {
  AddressDao(AppDatabase db) : super(db);

  Future<int> insertAddress({
    required String address,
    String? title,
    String? entrance,
    String? apartment,
    String? intercom,
    required double lat,
    required double long,
    required bool tmp,
  }) async {
    var item = AddressesCompanion(
      address: Value(address),
      title: Value(title),
      apartment: Value(apartment),
      entrance: Value(entrance),
      intercom: Value(intercom),
      tmp: Value(tmp),
      lat: Value(lat),
      long: Value(long),
    );
    var id = await into(addresses).insert(item);
    return id;
  }

  Stream<List<AddressData>> streamItems() {
    return (select(addresses)..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .watch();
  }

  Stream<List<AddressData>> streamLast() {
    return (select(addresses)
          ..orderBy([
            (t) => OrderingTerm(expression: t.used, mode: OrderingMode.desc)
          ])
          ..limit(2))
        .watch();
  }

  Future<bool> updateUsed({required AddressData a}) async {
    var item = AddressData(
        id: a.id,
        address: a.address,
        title: a.title,
        intercom: a.intercom,
        entrance: a.entrance,
        apartment: a.apartment,
        tmp: a.tmp,
        lat: a.lat,
        long: a.long,
        used: DateTime.now());
    var res = await update(addresses).replace(item);
    return res;
  }

  Future<bool> updateAddress({required AddressData item}) async {
    var res = await update(addresses).replace(item);
    return res;
  }

  Future<int> deleteAddress({required AddressData item}) async {
    var res = await delete(addresses).delete(item);
    return res;
  }

  Future<void> deleteTmpAddress() async {
    var tmpItems =
        await (select(addresses)..where((tbl) => tbl.tmp.equals(true))).get();
    if (tmpItems.length > 0) {
      await batch((batch) async {
        for (var item in tmpItems) {
          await delete(addresses).delete(item);
        }
      });
    }
  }
}

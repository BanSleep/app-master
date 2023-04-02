import 'package:cvetovik/core/db/conv/str_list_to_column_conv.dart';
import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('FavoriteData')
class Favorites extends Table {
  IntColumn get favoriteId => integer()();
  IntColumn get id => integer()();
  TextColumn get sku => text().withLength(min: 0, max: 300)();
  TextColumn get title => text().withLength(min: 0, max: 300)();
  TextColumn get image => text().withLength(min: 0, max: 200)();
  IntColumn get price => integer()();
  IntColumn get maxPrice => integer()();
  IntColumn get regularPrice => integer()();
  IntColumn get priceTime => integer()();
  IntColumn get bonus => integer()();
  TextColumn get badges => text()
      .withLength(min: 0, max: 200)
      .map(const StrListToColumnConv())
      .nullable()();
  RealColumn get averageMark => real().nullable()();
  //IntColumn get catalogId => integer()();

  @override
  Set<Column> get primaryKey => {favoriteId};
}

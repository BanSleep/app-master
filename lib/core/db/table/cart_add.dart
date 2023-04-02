import 'package:moor_flutter/moor_flutter.dart';

class CartAdd extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer()();
  //customConstraint('REFERENCES cartmain (id)')
  IntColumn get mainId => integer()();
  TextColumn get title => text().withLength(min: 0, max: 300)();
  TextColumn get image => text().withLength(min: 0, max: 200)();
  IntColumn get price => integer()();
}

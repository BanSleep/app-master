import 'package:cvetovik/core/db/conv/str_list_to_column_conv.dart';
import 'package:cvetovik/core/db/conv/version_to_column_conv.dart';
import 'package:moor_flutter/moor_flutter.dart';

class CartMain extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 0, max: 300)();
  IntColumn get productId => integer()();
  IntColumn get catalogId => integer()();
  IntColumn get count => integer()();
  IntColumn get bonus => integer()();
  IntColumn get price => integer()();
  IntColumn get regularPrice => integer()();
  TextColumn get image => text().withLength(min: 0, max: 200)();
  TextColumn get badges => text()
      .withLength(min: 0, max: 200)
      .map(const StrListToColumnConv())
      .nullable()();
  TextColumn get versions => text()
      .withLength(min: 0, max: 400)
      .map(const VersionToColumnConv())
      .nullable()();
  TextColumn get versionTitle =>
      text().withLength(min: 0, max: 200).nullable()();
}

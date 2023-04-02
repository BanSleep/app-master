import 'package:cvetovik/core/db/conv/str_list_to_column_conv.dart';
import 'package:cvetovik/core/db/conv/version_to_column_conv.dart';
import 'package:cvetovik/core/db/table/addresses.dart';
import 'package:cvetovik/core/db/table/cart_add.dart';
import 'package:cvetovik/core/db/table/cart_main.dart';
import 'package:cvetovik/core/db/table/favorites.dart';
import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:moor_flutter/moor_flutter.dart';


part 'app_database.g.dart';

@UseMoor(tables: [CartMain, CartAdd, Favorites, Addresses])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'app.db',
          logStatements: true,
        )));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(beforeOpen: (detail) async {
        //PRAGMA foreign_keys = ON
        await customStatement('PRAGMA temp_store = MEMORY;');
      }, onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 2) {
          try {
            for (final table in allTables.toList().reversed) {
              await m.deleteTable(table.actualTableName);
              await m.createTable(table);
            }
          } catch (e) {
            print(e);
          }
        }
      });
}

import 'package:moor_flutter/moor_flutter.dart';

@DataClassName('AddressData')
class Addresses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get address => text().withLength(min: 0, max: 400)();
  TextColumn get title => text().withLength(min: 0, max: 400).nullable()();
  TextColumn get entrance => text().withLength(min: 0, max: 10).nullable()();
  TextColumn get apartment => text().withLength(min: 0, max: 10).nullable()();
  TextColumn get intercom => text().withLength(min: 0, max: 10).nullable()();
  BoolColumn get tmp => boolean().withDefault(const Constant(false))();
  RealColumn get lat => real()();
  RealColumn get long => real()();
  DateTimeColumn get used => dateTime().withDefault(currentDateAndTime)();
}

import 'dart:convert';

import 'package:moor_flutter/moor_flutter.dart';

class StrListToColumnConv extends TypeConverter<List<String>, String> {
  const StrListToColumnConv();

  @override
  List<String>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    return List<String>.from(json.decode(fromDb).map((x) => x.toString()));
  }

  @override
  String? mapToSql(List<String>? value) {
    if (value == null) {
      return null;
    }
    var json = jsonEncode(value);
    return json;
  }
}

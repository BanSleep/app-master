import 'dart:convert';

import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:moor_flutter/moor_flutter.dart';

class VersionToColumnConv extends TypeConverter<List<Version>?, String> {
  const VersionToColumnConv();

  @override
  List<Version>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    Iterable raw = json.decode(fromDb);
    List<Version> versions =
        List<Version>.from(raw.map((e) => Version.fromJson(e)));
    return versions;
  }

  @override
  String? mapToSql(List<Version>? value) {
    if (value == null) {
      return null;
    }
    var json = jsonEncode(value);
    return json;
  }
}

import 'package:json_annotation/json_annotation.dart';

class IntFromStringConverter implements JsonConverter<int, String> {
  const IntFromStringConverter();

  @override
  int fromJson(String value) {
    return int.parse(value);
  }

  @override
  String toJson(int value) => value.toString();
}

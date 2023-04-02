import 'package:cvetovik/models/enums/app/os_type.dart';
import 'package:enum_to_string/enum_to_string.dart';

class AppDeviceInfo {
  final String id;
  final String model;
  final OsType os;

  AppDeviceInfo({required this.id, required this.model, required this.os});

  Map<String, dynamic> toJson() =>
      {"uniq_id": id, "name": model, "os": EnumToString.convertToString(os)};
}

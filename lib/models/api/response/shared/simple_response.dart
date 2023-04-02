import 'dart:convert';

import 'package:cvetovik/models/api/response/base/app_base_response.dart';

SimpleResponse simpleResponseFromJson(String str) =>
    SimpleResponse.fromJson(json.decode(str));

class SimpleResponse extends AppBaseResponse {
  SimpleResponse({
    result,
    this.errors,
  }) : super(result);

  List<String>? errors;

  factory SimpleResponse.fromJson(Map<String, dynamic> json) => SimpleResponse(
        result: json["result"],
        errors: json["errors"] != null
            ? List<String>.from(json["errors"].map((x) => x))
            : null,
      );
}

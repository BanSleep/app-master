import 'dart:convert';

import '../base/app_base_response.dart';

CheckCodeResponse checkCodeResponseFromJson(String str) =>
    CheckCodeResponse.fromJson(json.decode(str));

class CheckCodeResponse extends AppBaseResponse {
  CheckCodeResponse({
    result,
    this.data,
  }) : super(result);

  CheckResult? data;

  factory CheckCodeResponse.fromJson(Map<String, dynamic> json) =>
      CheckCodeResponse(
        result: json["result"],
        data: json["data"] != null ? CheckResult.fromJson(json["data"]) : null,
      );
}

class CheckResult {
  CheckResult({
    required this.id,
    required this.token,
    required this.newUser,
    this.errors,
  });

  int id;
  bool newUser;
  String token;
  List<String>? errors;

  factory CheckResult.fromJson(Map<String, dynamic> json) => CheckResult(
        id: json["id"],
        token: json["token"],
        newUser: json["new_user"],
        errors: json["errors"] != null
            ? List<String>.from(json["errors"].map((x) => x))
            : null,
      );
}

import 'dart:convert';

TokenResponse tokenResponseFromJson(String str) =>
    TokenResponse.fromJson(json.decode(str));

String tokenResponseToJson(TokenResponse data) => json.encode(data.toJson());

class TokenResponse {
  TokenResponse({
    required this.result,
    required this.data,
  });

  bool result;
  TokenData data;

  TokenResponse copyWith({
    required bool result,
    required TokenData data,
  }) =>
      TokenResponse(
        result: result,
        data: data,
      );

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        result: json["result"],
        data: TokenData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": data.toJson(),
      };
}

class TokenData {
  TokenData({
    required this.id,
    required this.token,
  });

  int id;
  String token;

  TokenData copyWith({
    required int id,
    required String token,
  }) =>
      TokenData(
        id: id,
        token: token,
      );

  factory TokenData.fromJson(Map<String, dynamic> json) => TokenData(
        id: json["id"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
      };
}

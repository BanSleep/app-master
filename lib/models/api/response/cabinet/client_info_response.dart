// To parse this JSON data, do
//
//     final clientInfoResponse = clientInfoResponseFromJson(jsonString);

import 'dart:convert';

import 'package:cvetovik/models/api/response/base/app_base_response.dart';

ClientInfoResponse clientInfoResponseFromJson(String str) =>
    ClientInfoResponse.fromJson(json.decode(str));

String clientInfoResponseToJson(ClientInfoResponse data) =>
    json.encode(data.toJson());

class ClientInfoResponse extends AppBaseResponse {
  ClientInfoResponse({
    result,
    this.data,
  }) : super(result);

  ClientData? data;

  factory ClientInfoResponse.fromJson(Map<String, dynamic> json) =>
      ClientInfoResponse(
        result: json["result"],
        data: json["data"] != null ? ClientData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": data != null ? data!.toJson() : null,
      };
}

class ClientData {
  ClientData({
    required this.id,
    required this.phone,
    required this.email,
    required this.emailVerified,
    required this.firstname,
    this.lastname,
    this.gender,
    this.birthday,
    this.bonusCard,
  });

  int id;
  String phone;
  String email;
  bool emailVerified;
  String firstname;
  String? lastname;
  String? gender;
  String? birthday;
  BonusCard? bonusCard;

  factory ClientData.fromJson(Map<String, dynamic> json) => ClientData(
        id: json["id"],
        phone: json["phone"],
        email: json["email"],
        emailVerified: json["email_verified"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        gender: json["gender"],
        birthday: json["birthday"],
        bonusCard: json["bonus_card"] != null
            ? BonusCard.fromJson(json["bonus_card"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "email": email,
        "email_verified": emailVerified,
        "firstname": firstname,
        "lastname": lastname,
        "gender": gender,
        "birthday": birthday,
        "bonus_card": bonusCard != null ? bonusCard!.toJson() : null,
      };

  bool get filled {
    bool isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;

    return isNotEmpty(phone) &&
        isNotEmpty(email) &&
        isNotEmpty(firstname) &&
        isNotEmpty(lastname) &&
        isNotEmpty(gender) &&
        isNotEmpty(birthday);
  }
}

class BonusCard {
  BonusCard({
    required this.isSet,
    this.number,
    this.balance,
    this.lastUpdate,
  });

  bool isSet;
  String? number;
  int? balance;
  int? lastUpdate;

  factory BonusCard.fromJson(Map<String, dynamic> json) => BonusCard(
        isSet: json["is_set"],
        number: json["number"],
        balance: json["balance"],
        lastUpdate: json["last_update"],
      );

  Map<String, dynamic> toJson() => {
        "is_set": isSet,
        "number": number,
        "balance": balance,
        "last_update": lastUpdate,
      };
}

import 'package:cvetovik/models/api/response/base/app_base_response.dart';

class ActivateBonusCardResponse extends AppBaseResponse {
  ActivateBonusCardResponse({
    result,
    this.data,
  }) : super(result);

  ActivateBonusCardModel? data;

  factory ActivateBonusCardResponse.fromJson(Map<String, dynamic> json) =>
      ActivateBonusCardResponse(
        result: json["result"],
        data: json["data"] != null
            ? ActivateBonusCardModel.fromJson(json["data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": data != null ? data!.toJson() : null,
      };
}

class ActivateBonusCardModel {
  String? method;
  String? cardType;
  String? cardNumber;
  String? cardCvc;
  String? firstname;
  String? lastname;
  String? gender;
  String? birthday;
  String? email;

  ActivateBonusCardModel({
    this.method,
    this.cardType,
    this.cardNumber,
    this.cardCvc,
    this.firstname,
    this.lastname,
    this.gender,
    this.birthday,
    this.email,
  });

  factory ActivateBonusCardModel.fromJson(Map<String, dynamic> json) =>
      ActivateBonusCardModel(
        method: json['method'],
        cardType: json['card_type'],
        cardNumber: json['card_number'],
        cardCvc: json['card_cvc'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        gender: json['gender'],
        birthday: json['birthday'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        "method": method,
        "card_type": cardType,
        "card_number": cardNumber,
        "card_cvc": cardCvc,
        "firstname": firstname,
        "lastname": lastname,
        "gender": gender,
        "birthday": birthday,
        "email": email,
      };
}

import 'package:cvetovik/models/api/response/base/app_base_response.dart';

class EditProfileResponse extends AppBaseResponse {
  EditProfileResponse({
    result,
    this.data,
  }) : super(result);

  EditProfileModel? data;

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) =>
      EditProfileResponse(
        result: json["result"],
        data: json["data"] != null
            ? EditProfileModel.fromJson(json["data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": data != null ? data!.toJson() : null,
      };
}

class EditProfileModel {
  EditProfileModel({
    this.firstname,
    this.lastname,
    this.gender,
    this.birthday,
    this.email,
  });

  String? firstname;
  String? lastname;
  String? gender;
  String? birthday;
  String? email;

  factory EditProfileModel.fromJson(Map<String, dynamic> json) =>
      EditProfileModel(
        firstname: json["firstname"],
        lastname: json["lastname"],
        gender: json["gender"],
        birthday: json["birthday"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "gender": gender,
        "birthday": birthday,
        "email": email,
      };
}

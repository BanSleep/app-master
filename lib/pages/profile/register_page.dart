import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/cabinet/client_info_response.dart';
import 'package:cvetovik/models/api/response/cabinet/edit_profile_response.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:cvetovik/pages/profile/profile_page.dart';
import 'package:cvetovik/pages/profile/profle_model.dart';
import 'package:cvetovik/pages/profile/remove_account/remove_account_page.dart';
import 'package:cvetovik/pages/user/personal/personal_area_page.dart';
import 'package:cvetovik/pages/user/personal/personal_start_model.dart';
import 'package:cvetovik/widgets/app_button.dart';
import 'package:cvetovik/widgets/date_picker_widget.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'remove_account/remove_account_success_page.dart';

class RegisterPage extends ConsumerStatefulWidget {
  // Переменная, указывающая, открывается ли страница для регистрации
  // нового пользователя или для редактирования данных.
  final bool isRegistered;
  final bool isCardActivation;
  final ClientData? clientData;
  final List<Region>? items;

  const RegisterPage({
    Key? key,
    required this.isRegistered,
    this.isCardActivation = false,
    this.clientData,
    this.items,
  }) : super(key: key);

  @override
  ConsumerState createState() => _RegisterPageState();
}

enum Genders {
  man,
  woman,
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final keyName = GlobalKey();
  final keyLastName = GlobalKey();
  final keyPhone = GlobalKey();
  final keyEmail = GlobalKey();
  final keyBirthday = GlobalKey();

  Genders? currentGender = Genders.man;

  final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');
  DateTime chosenDate = DateTime.now();
  String? firstName;
  String? lastName;
  String? email;
  late MaskTextInputFormatter _phoneFormatter;

  @override
  void initState() {
    super.initState();

    _phoneFormatter = MaskTextInputFormatter(
      mask: AppUi.phoneMask2,
    );

    if (widget.clientData != null) {
      if (widget.clientData!.gender != null) {
        currentGender =
            widget.clientData!.gender! == "male" ? Genders.man : Genders.woman;
      }
      if (widget.clientData!.birthday != null &&
          widget.clientData!.birthday != "") {
        chosenDate = _formatDate(widget.clientData!.birthday!);
      }
      if (widget.clientData!.lastname != null) {
        lastName = widget.clientData!.lastname;
      }
      if (widget.clientData!.email != "") {
        email = widget.clientData!.email;
      }
      firstName = widget.clientData!.firstname;
    }
  }

  @override
  Widget build(BuildContext context) {
    ProfileModel profile = ref.read(profileModelProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppAllColors.lightAccent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            widget.isCardActivation
                ? "Оформление бонусной карты"
                : !widget.isRegistered
                    ? AppRes.checkYourData
                    : AppRes.fillProfile,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppAllColors.lightBlack,
            ),
          ),
          backgroundColor: AppColors.fillColor,
          elevation: 0.0,
          centerTitle: true,
          leading: !widget.isRegistered
              ? SizedBox.shrink()
              : InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppAllColors.iconsGrey,
                  ),
                ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
              child: AppTextField(
                key: keyName,
                text: firstName,
                title: AppRes.yourName,
                textFieldType: TextFieldType.normal,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
              child: AppTextField(
                key: keyLastName,
                text: lastName,
                title: AppRes.yourLastName,
                textFieldType: TextFieldType.normal,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
              child: AppTextField(
                key: keyPhone,
                title: AppRes.yourPhone,
                textFieldType: TextFieldType.phone,
                hint: widget.clientData != null
                    ? (widget.clientData!.phone.contains("-")
                        ? widget.clientData!.phone
                        : _formatPhone(widget.clientData!.phone))
                    : null,
                readOnly: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
              child: AppTextField(
                key: keyEmail,
                text: widget.clientData != null
                    ? (widget.clientData!.emailVerified ? null : email)
                    : null,
                title: AppRes.email,
                textFieldType: TextFieldType.email,
                readOnly: widget.clientData != null
                    ? (widget.clientData!.emailVerified ? true : false)
                    : false,
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppRes.gender),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: AppAllColors.iconsGrey,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Radio(
                          value: Genders.man,
                          groupValue: currentGender,
                          onChanged: (Genders? value) {
                            setState(() {
                              currentGender = value;
                            });
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppAllColors.lightDarkGreen,
                        ),
                        Text(AppRes.man),
                        SizedBox(
                          width: 24.w,
                        ),
                        Radio(
                          value: Genders.woman,
                          groupValue: currentGender,
                          onChanged: (Genders? value) {
                            setState(() {
                              currentGender = value;
                            });
                          },
                          activeColor: AppAllColors.lightDarkGreen,
                        ),
                        Text(AppRes.woman),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 6.h, bottom: 12.h, left: 10.w, right: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    AppRes.birthDate,
                    style: AppTextStyles.textField
                        .copyWith(color: AppAllColors.lightBlack),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  DatePickerWidget(
                    timeRanges: null,
                    minDate: DateTime.utc(1920),
                    maxDate: DateTime.now(),
                    birthDate: widget.clientData != null
                        ? (widget.clientData!.birthday != null &&
                                widget.clientData!.birthday! != ""
                            ? _formatDate(widget.clientData!.birthday!)
                            : null)
                        : null,
                    onUpdate: (dateTime) {
                      chosenDate = dateTime;
                    },
                  ),
                ],
              ),
            ),
            // widget.isRegistered
            //     ? Row(
            //         children: <Widget>[
            //           Expanded(
            //             flex: 3,
            //             child: Padding(
            //               padding: EdgeInsets.symmetric(
            //                   vertical: 12.h, horizontal: 10.w),
            //               child: AppTextField(
            //                 title: "Номер карты",
            //                 hint: "0000 0000 0000 0000",
            //               ),
            //             ),
            //           ),
            //           Expanded(
            //             flex: 1,
            //             child: Padding(
            //               padding: EdgeInsets.symmetric(
            //                   vertical: 12.h, horizontal: 10.w),
            //               child: AppTextField(
            //                 title: "CVC",
            //                 hint: "000",
            //               ),
            //             ),
            //           ),
            //         ],
            //       )
            //     : Container(),
            AppButton(
              title: widget.isCardActivation ? "Оформить" : AppRes.save,
              tap: () async {
                var lastname = (keyLastName.currentState != null)
                    ? (keyLastName.currentState as GetStrMixin).value()
                    : "";
                var firstname = (keyName.currentState != null)
                    ? (keyName.currentState as GetStrMixin).value()
                    : "";
                //widget.clientData?.phone = (keyPhone.currentState != null) ? (keyPhone.currentState as GetStrMixin).value() : "";
                var email = (keyEmail.currentState != null)
                    ? (keyEmail.currentState as GetStrMixin).value()
                    : "";
                if (widget.clientData != null) {
                  // для изменения информации на экране профиля
                  widget.clientData?.firstname = firstname;
                  widget.clientData?.lastname = lastname;
                  widget.clientData?.gender =
                      currentGender == Genders.man ? "male" : "female";
                  widget.clientData?.birthday = chosenDate != DateTime.now()
                      ? dateFormatter.format(chosenDate)
                      : "";
                  widget.clientData?.email = email;
                }
                print("email before: $email");
                EditProfileModel data = EditProfileModel(
                  firstname: firstname,
                  lastname: lastname,
                  gender: currentGender == Genders.man ? "male" : "female",
                  birthday: chosenDate != DateTime.now()
                      ? dateFormatter.format(chosenDate)
                      : "",
                  email: email,
                );
                print(
                    "send data to edit profile endpoint: ${data.toJson().toString()}");
                bool result = (await profile.editProfile(data)).result;
                AppUi.hideKeyboard(context);
                if (result) {
                  await _goToProfile(context);
                } else {
                  AppUi.showToast(context, "Не оставляйте поля пустыми");
                }
              },
              white: false,
            ),
            SizedBox(
              height: 6.h,
            ),
            widget.isRegistered
                ? AppButton(
                    title: "Удалить аккаунт",
                    tap: () async {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return RemoveAccountPage();
                      }));
                    },
                  )
                : AppButton(
                    title: "Заполнить позже",
                    tap: () => _goToProfile(context),
                    white: true,
                  ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  _goToProfile(context) async {
    final state = ref.watch(personalStartModelProvider);
    ClientData? clientData;

    state.when(
      initializing: () {},
      loaded: (data, info) {
        clientData = info.data;
      },
      error: (String? text) {
        print(text);
      },
    );

    var lastname = (keyLastName.currentState != null)
        ? (keyLastName.currentState as GetStrMixin).value()
        : "";
    var firstname = (keyName.currentState != null)
        ? (keyName.currentState as GetStrMixin).value()
        : "";
    var email = (keyEmail.currentState != null)
        ? (keyEmail.currentState as GetStrMixin).value()
        : "";

    clientData?.lastname = lastname;
    clientData?.firstname = firstname;
    clientData?.gender = currentGender == Genders.man ? "male" : "female";
    clientData?.phone = widget.clientData!.phone;
    clientData?.birthday =
        chosenDate != DateTime.now() ? dateFormatter.format(chosenDate) : "";
    clientData?.email = email;
    print("client data to send: ${clientData?.toJson().toString()}");
    if (widget.isCardActivation) {
      return Navigator.pop(context, clientData);
    } else {
      ref.read(personalStartModelProvider.notifier).init();
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget.isRegistered
              ? PersonalAreaPage(
                  items: widget.items!,
                  info: widget.clientData,
                )
              : ProfilePage(),
        ),
        (r) => false,
      );
    }
  }

  DateTime _formatDate(String date) {
    print("_formatDate $date");
    List<String> formattedDate;
    if (date.contains('.')) {
      formattedDate = date.split('.');
    } else {
      formattedDate = date.split('-');
    }
    return DateTime.parse(
        "${formattedDate[2]}-${formattedDate[1]}-${formattedDate[0]}");
  }

  String _formatPhone(String phone) {
    return _phoneFormatter.maskText(phone);
  }
}

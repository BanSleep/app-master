import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/cabinet/activate_bonus_card_response.dart';
import 'package:cvetovik/models/api/response/cabinet/client_info_response.dart';
import 'package:cvetovik/pages/profile/register_page.dart';
import 'package:cvetovik/widgets/app_button.dart';
import 'package:cvetovik/widgets/dialog/dialog.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import 'bonus_card_model.dart';

class ActivateBonusCardPage extends ConsumerStatefulWidget {
  final ClientData? clientData;
  final BonusCardModel bonusCardApiService;

  const ActivateBonusCardPage({
    Key? key,
    required this.clientData,
    required this.bonusCardApiService,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ActivateBonusCardPageState();
}

class _ActivateBonusCardPageState extends ConsumerState<ActivateBonusCardPage> {
  final keyNumber = GlobalKey();
  final keyCvc = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppAllColors.lightAccent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.fillColor,
          elevation: 0.0,
          title: Text(
            "Активация бонусной карты",
            style: AppTextStyles.titleLarge.copyWith(
              color: AppAllColors.lightBlack,
            ),
          ),
          centerTitle: true,
          leading: InkWell(
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
                key: keyNumber,
                title: "Номер карты",
                hint: "0000 0000 0000 0000",
                textFieldType: TextFieldType.cardNumber,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
              child: AppTextField(
                key: keyCvc,
                title: "CVC",
                hint: "000",
                textFieldType: TextFieldType.cardCvc,
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            AppButton(
              title: "Активировать",
              tap: () => _onActivateCard(
                  widget.clientData, widget.bonusCardApiService),
              white: false,
            ),
            SizedBox(
              height: 6.h,
            ),
          ],
        ),
      ),
    );
  }

  _onActivateCard(ClientData? clientData, bonusCardApiService) async {
    String cardNumber =
        _processCardNumber((keyNumber.currentState as GetStrMixin).value());
    String cardCvc =
        _processCardCvc((keyCvc.currentState as GetStrMixin).value());
    print("card info: $cardNumber $cardCvc");

    if (!_isValidCardNumber(cardNumber)) {
      AppUi.hideKeyboard(context);
      AppUi.showToast(
          context, "Проверьте правильность введенного номера карты");
      return;
    }

    if (!_isValidCardCvc(cardCvc)) {
      AppUi.hideKeyboard(context);
      AppUi.showToast(context, "Проверьте правильность введенного CVC");
      return;
    }

    if (clientData == null || !clientData.filled) {
      clientData = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterPage(
            isRegistered: true,
            isCardActivation: true,
            clientData: clientData,
          ),
        ),
      );
    }

    if (clientData == null || !clientData.filled) {
      AppUi.showToast(
        context,
        "Для активации карты необходимо заполнить все данные в профиле",
      );
      return;
    }

    // make request
    var data = ActivateBonusCardModel(
      method: "activate",
      cardType: "cvetovik",
      // если метод activate - cvetovik или ekp
      cardNumber: cardNumber.replaceAll(' ', ''),
      // если метод activate - номер карты цветовик или ЕКП
      cardCvc: cardCvc,
      // если метод activate тип карты cvetovik - CVC карты
      firstname: clientData.firstname,
      lastname: clientData.lastname,
      gender: clientData.gender,
      email: clientData.email,
      birthday: clientData.birthday,
    );
    print("request activate bonus card: ${data.toJson().toString()}");
    ActivateBonusCardResponse bonusData =
        await bonusCardApiService.activateBonusCard(data);
    if (bonusData.result) {
      print("bonus card activate result received: ${bonusData.result}");
      print("bonus card activate data received: ${bonusData.data}");

      clientData.bonusCard?.number = bonusData.data?.cardNumber;
      clientData.bonusCard?.balance = 0;
      clientData.bonusCard?.isSet = true;

      // refresh bottom sheet
      Navigator.of(context).pop(true);
      await Future.delayed(Duration(milliseconds: 200));
      AppUi.showAppBottomSheet(
        context: context,
        child: TextDialog(
          title: "Поздравляем!",
          description: "Ваша скидочная карта успешно активирована",
        ),
      );
    } else {
      print("bonus data : ${bonusData.toJson().toString()}");
      AppUi.hideKeyboard(context);
      AppUi.showToast(context,
          "Что-то пошло не так :(\nПроверьте правильность введенных данных");
    }
  }

  // order of operations matters
  String _processCardNumber(String number) {
    if (number.isEmpty) return "";
    number = number.replaceAll(" ", "");
    if (number.length < 16) return "";
    number = number.substring(0, 16);
    return number;
  }

  // order of operations matters
  String _processCardCvc(String cvc) {
    if (cvc.isEmpty) return "";
    cvc = cvc.replaceAll(" ", "");
    if (cvc.length < 3) return "";
    cvc = cvc.substring(0, 3);
    return cvc;
  }

  bool _isValidCardNumber(String number) {
    if (number.length != 16) return false;
    return true;
  }

  bool _isValidCardCvc(String cvc) {
    if (cvc.length != 3) return false;
    return true;
  }
}

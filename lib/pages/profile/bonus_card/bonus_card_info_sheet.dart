import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/cabinet/activate_bonus_card_response.dart';
import 'package:cvetovik/models/api/response/cabinet/client_info_response.dart';
import 'package:cvetovik/pages/profile/bonus_card/activate_bonus_card_page.dart';
import 'package:cvetovik/pages/profile/bonus_card/bonus_card_model.dart';
import 'package:cvetovik/pages/profile/profile_navigation.dart';
import 'package:cvetovik/pages/profile/register_page.dart';
import 'package:cvetovik/widgets/dialog/dialog.dart';
import 'package:cvetovik/widgets/share/line_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bonus_card_utils.dart';
import 'bonus_card_widget.dart';

// ignore: must_be_immutable
class BonusCardInfoSheet extends ConsumerWidget {
  // Переменная, которая проверяет, активирована ли бонусная карта.
  // В зависимости от неё меняется шторка с информацией о бонусной карте.
  bool isActivated = false;
  ClientData? clientData;

  BonusCardInfoSheet(
    this.isActivated, {
    this.clientData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String bonusCardBCounter = "";
    String bonusCardNumber = "";

    bool isBonusCard = (clientData != null &&
        clientData!.bonusCard != null &&
        clientData!.bonusCard!.balance != null);
    int count = isBonusCard ? clientData!.bonusCard!.balance! : 0;
    bonusCardBCounter = '$count ${AppRes.bonus}';
    bonusCardNumber =
        isBonusCard ? clientData!.bonusCard!.number.toString() : '';
    if (bonusCardNumber.isNotEmpty)
      bonusCardNumber = formattedNumberCard(bonusCardNumber);

    BonusCardModel bonusCardApiService = ref.read(bonusCardModelProvider);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 8.h,
              bottom: 36.h,
            ),
            child: LineSheet(),
          ),
          Text(
            AppRes.bonusCard,
            style: AppTextStyles.titleLarge,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 15.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ShaderMask(
                  shaderCallback: (bounds) {
                    if (isActivated) {
                      return LinearGradient(
                        colors: [Colors.white, Colors.white],
                      ).createShader(bounds);
                    }
                    // Накладываем прозрачный белый цвет, если карта не активирована.
                    return LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.1)
                      ],
                    ).createShader(bounds);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: BonusCardWidget(
                      bonusCountMess: bonusCardBCounter,
                      numberCard: bonusCardNumber,
                      isInSheet: true,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    if (!isActivated)
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: ProfileNavigationButton(
                          title: AppRes.activatePlasticCard,
                          function: () => _onActivateCard(
                            context,
                            clientData,
                            bonusCardApiService,
                          ),
                        ),
                      ),
                    if (!isActivated)
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: ProfileNavigationButton(
                          title: AppRes.createVirtualCard,
                          function: () => _onCreateVirtualCard(
                            context,
                            clientData,
                            bonusCardApiService,
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: ProfileNavigationButton(
                        title: AppRes.aboutBonusProgram,
                        function: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onCreateVirtualCard(
      context, ClientData? clientData, bonusCardApiService) async {
    // make request

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
      Navigator.pop(context, false);
      return;
    }

    var data = ActivateBonusCardModel(
      method: "register",
      firstname: clientData.firstname,
      lastname: clientData.lastname,
      gender: clientData.gender,
      email: clientData.email,
      birthday: clientData.birthday,
    );
    print("data sending out: ${data.toJson().toString()}");
    ActivateBonusCardResponse bonusData =
        await bonusCardApiService.activateBonusCard(data);
    if (bonusData.result) {
      // update state
      isActivated = true;
      clientData.bonusCard?.number = bonusData.data?.cardNumber;
      clientData.bonusCard?.balance = 0;
      clientData.bonusCard?.isSet = true;
    }
    // todo {"result":true,"data":{"card_number":"0000000001150218"}}
    // todo {"result":false,"errors":["card already set"]}
    // todo {"result":false,"errors":["Ошибка. На данный номер телефона уже зарегистрирована карта!"]}

    // refresh bottom sheet
    Navigator.of(context).pop();
    AppUi.showAppBottomSheet(
      context: context,
      child: TextDialog(
        title: "Поздравляем!",
        description: "Ваша скидочная карта успешно выпущена",
      ),
    );
  }

  _onActivateCard(BuildContext context, ClientData? clientData,
      BonusCardModel bonusCardApiService) async {
    // refresh bottom sheet
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (con) => ActivateBonusCardPage(
          clientData: clientData,
          bonusCardApiService: bonusCardApiService,
        ),
      ),
    ).then((value) {
      if (value == true) {
        isActivated = true;
        Navigator.of(context).pop();
      }
    });
  }
}

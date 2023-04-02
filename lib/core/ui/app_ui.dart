import 'dart:io';

import 'package:cvetovik/const/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_all_colors.dart';
import 'app_text_styles.dart';

class AppUi {
  static final EdgeInsetsGeometry pagePadding =
      EdgeInsets.fromLTRB(10.w, 17.h, 10.w, 13.h);
  static final EdgeInsetsGeometry appBarPadding =
      EdgeInsets.fromLTRB(10.w, 18.h, 10.w, 13.w);
  static final BoxShadow baseShadow = BoxShadow(
    color: Color(0x0f000000),
    blurRadius: 15.r,
    offset: Offset(0, 4.w),
  );

  static final sheetBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0.r), topRight: Radius.circular(20.0.r)));

  static final buttonRoundedBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.r)),
  );

  static final buttonActionStyle = ButtonStyle(
      shadowColor: MaterialStateProperty.all(Colors.transparent),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          buttonRoundedBorder),
      backgroundColor: MaterialStateProperty.all(AppAllColors.lightAccent));

  static final buttonActionWhiteStyle = ButtonStyle(
      shadowColor: MaterialStateProperty.all(Colors.transparent),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          buttonRoundedBorder.copyWith(
              side: BorderSide(color: AppAllColors.lightAccent))),
      backgroundColor: MaterialStateProperty.all(Colors.white));

  static final roundedContainerDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10.r),
    color: Colors.white,
  );

  static final sheetDecoration = BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.r),
      topRight: Radius.circular(10.r),
      bottomLeft: Radius.circular(0),
      bottomRight: Radius.circular(0),
    ),
    color: Colors.white,
  );
  static final double opacity = 0.3;
  static final double iconSize = 18.h;
  static final double leadingWidth = 30;
  static final double placeMarkScale = 1.5;
  static final double placeMarkScaleShop = 2.0;
  static final String phoneMask = '+7 (###) ###-##-##';
  static final String phoneMask2 = '+# (###) ###-##-##';
  static final String bonusCardNumberMask = '#### #### #### ####';
  static final String bonusCardCvcMask = '###';
  static final String dateFormatStr = 'dd.MM.yyyy';
  static void showToastFromRes(BuildContext context, bool res) {
    var mess = (res) ? AppRes.success : AppRes.error;
    showToast(context, mess);
  }

  static void showToast(BuildContext context, String mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        mess,
        style: AppTextStyles.titleVerySmall.copyWith(),
      ),
      backgroundColor: AppAllColors.iconsGreen1,
      //behavior: SnackBarBehavior.floating,
      /*shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.r))),*/
      duration: Duration(seconds: 2),
    ));
  }

  static Future<T> showAppBottomSheet<T>(
      {required BuildContext context,
      required Widget child,
      bool isShape = true}) async {
    ShapeBorder? _getShape() {
      if (isShape) {
        return AppUi.sheetBorder;
      } else
        return (Platform.isIOS) ? AppUi.sheetBorder : null;
    }

    var res = await showModalBottomSheet(
        shape: _getShape(),
        useRootNavigator: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return child;
        },
        context: context);
    return res;
  }

  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_all_colors.dart';

class AppTextStyles {
  //static double delta = 2;

  //заголовокОченьКрупный
  static final titleVeryLarge = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 24.sp,
    decoration: TextDecoration.none,
    letterSpacing: 0,
  ));

  static final title22 = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 22.sp,
    decoration: TextDecoration.none,
    letterSpacing: 0,
  ));

  //заголовокМелкий
  static final titleSmall13 = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          fontSize: 13.41.sp,
          color: AppAllColors.commonColorsYellow));

  //заголовокМелкий
  static final titleSmall = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 16.sp,
          color: AppAllColors.lightBlack
          //height: 1.1875,
          ));

  static final titleSmall400 = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 16.sp,
          color: AppAllColors.lightBlack
          //height: 1.1875,
          ));

  //описаниеБольшой
  static final descriptionLarge = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 11.sp,
    color: AppAllColors.lightDarkGrey,
  ));

  //текстПолеЖирный
  static final textFieldBold = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 10.sp,
          height: 1.2,
          color: AppAllColors.lightDarkGrey));
  //текстПолеМаленький
  static final textFieldSmall = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 10.sp,
          height: 1.2,
          color: AppAllColors.lightDarkGrey));

  //текстМеньшеСреднегоЖирный
  static final textLessMediumBold = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 11.sp,
          height: 1.3,
          color: AppAllColors.greyBd));

  //текстМеньшеСреднего
  static final textLessMedium = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 11.sp,
          height: 1.3,
          color: AppAllColors.lightBlack));

  //текстОченьМелкий
  static final textVerySmall = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 9.sp,
          letterSpacing: 0,
          color: AppAllColors.lightBlack));

  //текстКрупный
  static final textLarge = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 14.sp,
          color: AppAllColors.lightDarkGrey));

  static final textDateTime = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 14.sp,
          color: AppAllColors.lightDarkGrey));

  //текстСреднийМедиум
  static final textMedium = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 12.sp,
          decoration: TextDecoration.none,
          letterSpacing: 0,
          color: AppAllColors.lightBlack));

  //описаниеСредний
  static final descriptionMedium = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 8.sp,
          //height: 9.6,
          color: AppAllColors.lightDarkGrey));

  //описаниеСреднийЖирный
  static final descriptionMediumBold = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.normal,
          fontSize: 10.sp,
          //height: 9.6,
          color: AppAllColors.lightAccent));

  static final descriptionMedium10 = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 10.sp,
          color: AppAllColors.greyBd));

  static final descriptionMedium10Black = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 10.sp,
          color: AppAllColors.lightBlack));

  //текстСреднийЖирный
  static final textMediumBold = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 12.sp,
          height: 1.2,
          color: AppAllColors.lightBlack));

  //текстСредний8Жирный
  static final textMedium8Bold = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 8.657.sp,
    decoration: TextDecoration.none,
  ));

  //текстСредний9
  static final textMedium9 = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 9.24.sp,
    decoration: TextDecoration.none,
  ));

  //ТекстМелкийжирный
  static final textSmallBold = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 10.sp,
  ));

  //ТекстОченьмелкийжирный
  static final textVerySmallBold = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 7.sp,
  ));

  //текстСредний11
  static final textMedium11 = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 11.9.sp,
    color: AppAllColors.lightBlack,
    decoration: TextDecoration.none,
  ));

  //текстПоле
  static final textField = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 12.sp,
    decoration: TextDecoration.none,
    letterSpacing: 0,
  ));

  //заголовокКрупный
  static final titleLarge = GoogleFonts.manrope(
      textStyle: (TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 18.sp,
    letterSpacing: 0,
  )));

  static final titleLargeSemiBold = GoogleFonts.manrope(
      textStyle: (TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 18.sp,
    letterSpacing: 0,
  )));

  static final titleLargeSemiBold16 = GoogleFonts.manrope(
      textStyle: (TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 16.sp,
    letterSpacing: 0,
  )));

  //заголовокКрупный
  static final titleLarge22 = GoogleFonts.manrope(
      textStyle: (TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 22.sp,
    letterSpacing: 0,
  )));

  //перечркнутая цена
  static final textRegularPrice = GoogleFonts.manrope(
      textStyle: TextStyle(
    decoration: TextDecoration.lineThrough,
    color: AppAllColors.lightDarkGrey,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 12.sp,
  ));

  static final textActionSelected = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 15.sp,
          color: AppAllColors.lightDarkGrey));

  static final textAction = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 17.sp,
          color: AppAllColors.lightAccent));

  static final textAlarm = GoogleFonts.manrope(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 17.sp,
          color: AppAllColors.commonColorsRed));

  //заголовокМелкий13Полужирный
  static final smallTitle13 = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 13.412.sp,
    decoration: TextDecoration.none,
    letterSpacing: 0,
  ));

  static final smallTitle13NotBold = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 13.412.sp,
    decoration: TextDecoration.none,
    letterSpacing: 0,
  ));

  //заголовокМелкий14Полужирный
  static final titleSmall14 = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 14.sp,
    decoration: TextDecoration.none,
    letterSpacing: 0,
  ));

  //заголовокОченьМелкий
  static final titleVerySmall = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 14.sp,
    decoration: TextDecoration.none,
  ));

  //ОписаниеМелкий6
  static final descriptionSmall6 = GoogleFonts.manrope(
      textStyle: TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 6.82.sp,
  ));

  //заголовокКрупный48
  static const titleLarge48 = TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 48,
    decoration: TextDecoration.none,
    letterSpacing: 0,
  );

  //заголовокКрупный32
  static const titleLarge32 = TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 32,
    decoration: TextDecoration.none,
    letterSpacing: 0,
  );
}

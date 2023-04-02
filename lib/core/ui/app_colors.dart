import 'package:flutter/material.dart';

class AppColors {
  static const _primaryValue = 0xff2BCB4E;
  static const primary = const Color(_primaryValue);
  static const unActive = const Color(0xff9D9E9E);
  static const fillColor = const Color(0xffF6F6F6);
  static const Map<int, Color> _primarySwitch = {
    50: primary,
    100: primary,
    200: primary,
    300: primary,
    400: primary,
    500: primary,
    600: primary,
    700: primary,
    800: primary,
    900: primary
  };

  static const primaryMaterial = MaterialColor(_primaryValue, _primarySwitch);
  static const back = Color(0xff9D9D9D);

  static const darkBackground = Colors.black;
  static const lightBackground = Colors.white;

  static const lightBg2 = Color(0xffFCFCFC);
  static const lightBg3 = Color(0xffF6F6F6);

  static const alarm = Color(0xffFF6075);
  static const itemTitle = Color(0xff333333);
  static const textArea = Color(0xffF6F6F6);
  static const yellow = Color(0xffFFC700);
  static const orange = Color(0xffFF861B);
  static const blue = Color(0xff60A0FF);
  static const green = Color(0xff2BCBAE);
  static const grey = Color(0xffB6B6B6);
  static const black = Color(0xff333333);
  static const lightGreen = Color(0xffE9FFEE);
  static Color getBackground(bool isDark) {
    return (isDark)
        ? AppColors.darkBackground
        : AppColors.lightBackground; //AppColors.lightBg2;
  }

  static Color invertBackground(bool isDark) {
    return (isDark) ? AppColors.lightBackground : AppColors.darkBackground;
  }

  static Brightness getBrightness(bool isDark) {
    return (isDark) ? Brightness.light : Brightness.dark;
  }

  static Color getInactiveColor(bool isDark) {
    return (isDark) ? AppColors.lightBackground : AppColors.unActive;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

mixin AppThemeObserver {
  static SystemUiOverlayStyle getUiOverlayStyle({bool isDark = false}) {
    Color background = AppColors.getBackground(isDark);
    Brightness brightness = AppColors.getBrightness(isDark);
    var style = SystemUiOverlayStyle(
        statusBarColor: background,
        systemNavigationBarIconBrightness: brightness,
        systemNavigationBarColor: background,
        statusBarIconBrightness: brightness,
        systemNavigationBarDividerColor: Colors.transparent);
    return style;
  }

  void updateTheme(bool isDark) {
    var style = getUiOverlayStyle();
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}

import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_theme_observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: AppAllColors.lightAccent,
    scaffoldBackgroundColor: AppColors.lightBg2,
    textTheme: GoogleFonts.manropeTextTheme(),
    iconTheme: IconThemeData(color: AppColors.darkBackground),
    splashColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: AppColors.darkBackground),
      elevation: 0,
      titleSpacing: 0,
      centerTitle: true,
      //backwardsCompatibility: false,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: AppThemeObserver.getUiOverlayStyle(isDark: false),
    ),
  );
}

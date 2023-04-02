import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: AppColors.primary,
    backgroundColor: AppColors.darkBackground,
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: GoogleFonts.manropeTextTheme().apply(
        displayColor: AppColors.lightBackground, bodyColor: Colors.white),
    iconTheme: IconThemeData(color: AppColors.lightBackground),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      titleSpacing: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.lightBackground),
      backgroundColor: AppColors.darkBackground,
    ),
    splashColor: Colors.transparent,
  );
}

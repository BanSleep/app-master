import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension CustomTextStyle on TextTheme {
  TextStyle get text17 {
    return GoogleFonts.manrope(
        textStyle: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
    ));
  }

  TextStyle textAlarm(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .text17
        .copyWith(fontWeight: FontWeight.w400, color: AppColors.alarm);
  }

  TextStyle textAction(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .text17
        .copyWith(fontWeight: FontWeight.w400, color: AppColors.primary);
  }

  TextStyle textActionSelected(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .text17
        .copyWith(fontWeight: FontWeight.w400, color: Colors.grey[500]);
  }
}

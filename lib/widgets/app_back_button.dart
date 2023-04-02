import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton(
      {Key? key, required this.tap, this.color = AppColors.back})
      : super(key: key);
  final VoidCallback tap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: IconButton(
          onPressed: () {
            tap();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: AppUi.iconSize,
            color: color,
          )),
    );
  }
}

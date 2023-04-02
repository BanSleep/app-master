import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 36.w,
          height: 5.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2.5.r)),
            color: AppAllColors.lightDarkGrey,
          )),
    );
  }
}

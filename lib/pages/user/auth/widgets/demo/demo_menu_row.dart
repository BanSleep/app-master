import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DemoMenuRow extends StatelessWidget {
  const DemoMenuRow(
      {Key? key,
      required this.title,
      required this.icon,
      this.showDivider = true})
      : super(key: key);
  final String title;
  final String icon;
  final bool showDivider;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    icon,
                    height: 10.h,
                    width: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Text(title, style: AppTextStyles.descriptionSmall6),
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right,
                color: AppAllColors.lightAccent,
                size: 12.w,
              )
            ],
          ),
          if (showDivider) Divider(),
        ],
      ),
    );
  }
}

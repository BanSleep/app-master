import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShowItemRowWidget extends StatelessWidget {
  const ShowItemRowWidget({Key? key, required this.title, required this.icon})
      : super(key: key);
  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6.0.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                icon,
                height: 15.h,
                width: 15.h,
              ),
              SizedBox(
                width: 6.w,
              ),
              Text(
                title,
                style: AppTextStyles.textLessMedium,
                maxLines: 2,
              ),
            ],
          ),
          SizedBox(
            height: 12.h,
          ),
        ],
      ),
    );
  }
}

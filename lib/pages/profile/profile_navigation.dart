import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileNavigationButton extends StatelessWidget {
  final String title;
  final VoidCallback function;
  final SvgPicture? icon;

  ProfileNavigationButton(
      {required this.title, required this.function, this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        height: 54.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: icon != null ? icon! : Container(),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.textMediumBold
                            .copyWith(color: Colors.black),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppAllColors.lightAccent,
                size: 12.w,
              ),
            )
          ],
        ),
      ),
    );
  }
}

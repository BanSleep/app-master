import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DroidDialog extends StatelessWidget {
  const DroidDialog({Key? key, required this.text, required this.okTitle})
      : super(key: key);
  final String text;
  final String okTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r), color: Colors.white),
        //height: 140.h,
        width: 280.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(
                  child: Text(
                text,
                style: AppTextStyles.titleSmall400,
                textAlign: TextAlign.center,
              )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(okTitle.toUpperCase(),
                          style: AppTextStyles.textField
                              .copyWith(color: AppAllColors.commonColorsRed))),
                  SizedBox(
                    width: 40.w,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(AppRes.cancel.toUpperCase(),
                          style: AppTextStyles.textField
                              .copyWith(color: AppAllColors.commonColorsBlue))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

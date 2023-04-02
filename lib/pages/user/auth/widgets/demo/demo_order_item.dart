import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DemoOrderItem extends StatelessWidget {
  const DemoOrderItem(
      {Key? key, required this.title, required this.count, required this.price})
      : super(key: key);
  final String title;
  final String count;
  final String price;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10.w,
      ),
      child: Container(
        width: 159.20.w,
        height: 45.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.55.r),
          boxShadow: [
            BoxShadow(
              color: Color(0x0f000000),
              blurRadius: 8.53.r,
              offset: Offset(0, 2.27),
            ),
          ],
          color: Colors.white,
        ),
        padding: EdgeInsets.only(
          left: 11.w,
          right: 9.w,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.descriptionSmall6,
                    ),
                    Text(
                      "оплачен",
                      style: AppTextStyles.descriptionSmall6
                          .copyWith(color: AppAllColors.commonColorsBlue),
                    ),
                  ],
                ),
                SizedBox(height: 1.14.h),
                Text(
                  count,
                  style: AppTextStyles.descriptionSmall6.copyWith(
                      fontSize: 5.12.sp, color: AppAllColors.lightDarkGrey),
                ),
                SizedBox(height: 1.14.h),
                Text(
                  price,
                  style: AppTextStyles.descriptionSmall6.copyWith(
                      fontSize: 5.12.sp, color: AppAllColors.lightDarkGrey),
                ),
              ],
            ),
            SizedBox(width: 9.10),
            Icon(
              Icons.chevron_right,
              color: AppAllColors.lightAccent,
            ),
          ],
        ),
      ),
    );
  }
}

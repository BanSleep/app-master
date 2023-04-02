import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/products/models/count_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnUpdateStep = void Function(int step);

class CounterStep extends StatelessWidget {
  const CounterStep({Key? key, required this.onTap, required this.step})
      : super(key: key);

  final OnUpdateStep onTap;
  final CountInfo step;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(step.count);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Column(
          children: [
            Container(
              height: 39.w,
              width: 65.h,
              decoration: BoxDecoration(
                color: AppColors.lightBg3,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  step.count.toString(),
                  style: AppTextStyles.titleSmall14,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Visibility(
              visible: step.desc.isNotEmpty,
              child: Padding(
                padding: EdgeInsets.only(top: 5.0.h),
                child: Text(
                  step.desc,
                  style: AppTextStyles.textFieldBold
                      .copyWith(color: AppAllColors.lightAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

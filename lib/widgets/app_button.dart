import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.title,
    this.height = 0,
    required this.tap,
    this.white = true,
    this.leftPad,
    this.rightPad,
    this.withGreenBorder = false,
  }) : super(key: key);
  final String title;
  final double height;
  final double? leftPad;
  final double? rightPad;
  final VoidCallback tap;
  final bool white;
  final bool withGreenBorder;

  @override
  Widget build(BuildContext context) {
    var currHeight = (height > 0) ? height : 44.h;
    return Container(
      height: currHeight,
      width: double.infinity,
      margin: EdgeInsets.only(
        left: (leftPad != null) ? leftPad! : 7.w,
        right: (rightPad != null) ? rightPad! : 7.w,
        top: 2.h,
        bottom: 4.h,
      ),
      decoration: withGreenBorder
          ? BoxDecoration(
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.5), width: 2.r),
              borderRadius: BorderRadius.circular(10.r),
            )
          : null,
      child: ElevatedButton(
        onPressed: tap,
        style: _getButtonStyle(),
        child: Text(
          title,
          style: AppTextStyles.titleVerySmall.copyWith(color: _getFontColor()),
        ),
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    return (white)
        ? AppUi.buttonActionStyle
            .copyWith(backgroundColor: MaterialStateProperty.all(Colors.white))
        : AppUi.buttonActionStyle;
  }

  Color _getFontColor() {
    return (white) ? AppAllColors.lightAccent : Colors.white;
  }
}

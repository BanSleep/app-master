import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductBonusWidget extends StatelessWidget {
  final int bonus;
  final bool isSmall;
  const ProductBonusWidget(
      {Key? key, required this.bonus, this.isSmall = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double size = (isSmall) ? 8.32.h : 9.h;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SvgPicture.asset(
            AppIcons.balls,
            height: size,
            width: size,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Text(bonus.toString(),
              textAlign: TextAlign.start,
              maxLines: 2,
              style: (isSmall)
                  ? AppTextStyles.textVerySmall
                      .copyWith(fontWeight: FontWeight.w600)
                  : AppTextStyles.titleSmall13),
        )
      ],
    );
  }
}

import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/products/models/enum/product_badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'mixin/badge_mixin.dart';

class ProductBadgeWidget extends StatelessWidget with BadgeMixin {
  final ProductBadges badge;
  final bool isSmall;
  const ProductBadgeWidget({Key? key, required this.badge, this.isSmall = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0),
      child: Center(
        child: Container(
          //width: false ? 50.w: 28.w,
          height: (isSmall) ? 11.h : 18.h,
          decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius:
                  BorderRadius.all(Radius.circular(isSmall ? 4.r : 6.r))),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
              child: Text(
                getTitle(badge: badge),
                textAlign: TextAlign.center,
                style: (isSmall)
                    ? AppTextStyles.textVerySmallBold
                        .copyWith(color: Colors.white)
                    : AppTextStyles.textField
                        .copyWith(color: Colors.white, fontSize: 9.sp),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (badge) {
      case ProductBadges.hour:
        return AppColors.blue;
      case ProductBadges.hot:
        return AppColors.orange;
      case ProductBadges.newItem:
        return AppColors.green;
      // case ProductBadges.cashback:
      //   return AppColors.yellow;
      // case ProductBadges.bprice:
      //   return AppColors.orange;
      default:
        return Colors.white;
    }
  }
}

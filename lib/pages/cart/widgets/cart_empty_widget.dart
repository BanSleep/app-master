import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/providers/navbar_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/enums/app/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartEmptyWidget extends ConsumerWidget {
  const CartEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.getBackground(false),
      ),
      child: Scaffold(
        bottomNavigationBar: _getBottomNavBar(ref),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              10.w,
              10.h,
              10.w,
              10.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(children: [
                  Text(AppRes.cart, style: AppTextStyles.titleSmall),
                ]),
                Padding(
                  padding: EdgeInsets.only(
                    top: 94.h,
                    bottom: 70.h,
                  ),
                  child: Text(AppRes.yourCartEmpty,
                      style: AppTextStyles.titleLarge
                          .copyWith(color: AppAllColors.lightGrey2)),
                ),
                Image.asset(
                  AppIcons.emptyCart,
                  width: 265.w,
                  height: 220.h,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBottomNavBar(WidgetRef ref) {
    return Container(
      height: 77.h,
      color: AppAllColors.commonColorsWhite,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 14.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppRes.emptyCart,
              style: AppTextStyles.titleLarge,
            ),
            SizedBox(width: 10),
            Consumer(
              builder: (BuildContext context, watch, _) {
                return ConstrainedBox(
                  constraints:
                      BoxConstraints.tightFor(height: 38.h, width: 108.w),
                  child: ElevatedButton(
                    onPressed: () async {
                      ref.read(navBarProvider).onTap(TabItem.catalog);
                    },
                    style: AppUi.buttonActionStyle,
                    child: Text(
                      AppRes.byShopping,
                      style: AppTextStyles.titleVerySmall
                          .copyWith(color: Colors.white),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

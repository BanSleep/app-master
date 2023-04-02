import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/user/auth/widgets/demo/demo_menu_row.dart';
import 'package:cvetovik/pages/user/auth/widgets/demo/demo_order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth_number_page.dart';

class AuthStartPage extends StatelessWidget {
  const AuthStartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppAllColors.lightAccent,
      ),
      child: Scaffold(
        backgroundColor: AppAllColors.lightAccent,
        body: Padding(
          //+ kToolbarHeight
          padding: EdgeInsets.only(top: 48.h, left: 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: SvgPicture.asset(
                    AppIcons.logoWhite,
                    height: 42.h,
                    width: 36.w,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 22.h, bottom: 45.h),
                  child: Center(
                    child: Text(
                      AppRes.useAdvantage,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleVeryLarge
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          AppIcons.bonusCard,
                          width: 155.w,
                          height: 68.h,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Text(
                        AppRes.bonusSystem,
                        textAlign: TextAlign.left,
                        style: AppTextStyles.textMediumBold
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 38.h, left: 10.w, right: 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      children: [
                        Text(
                          AppRes.lastOrders,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.textMediumBold
                              .copyWith(color: Colors.white),
                        ),
                        DemoOrderItem(
                          title: "Заказ №1251 ",
                          count: "5 товаров",
                          price: "2500 ₽",
                        ),
                        DemoOrderItem(
                          title: "Заказ №1260 ",
                          count: "7 товаров",
                          price: "3000 ₽",
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _menuDemo(),
                      Text(
                        AppRes.allInfoOrders,
                        textAlign: TextAlign.left,
                        style: AppTextStyles.textMediumBold
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _nextButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuDemo() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 19.w),
      child: Container(
        //height: 120.h,
        width: 144.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(top: 8.0.h, left: 8.w, right: 8.w, bottom: 8.h),
          child: Column(
            children: [
              DemoMenuRow(
                title: AppRes.myOrders,
                icon: AppIcons.cart2,
              ),
              DemoMenuRow(
                title: AppRes.greatDates,
                icon: AppIcons.calendar,
              ),
              DemoMenuRow(
                title: AppRes.likeAddress,
                icon: AppIcons.geo,
              ),
              DemoMenuRow(
                title: AppRes.shops,
                icon: AppIcons.geo,
                showDivider: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nextButton(context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 41.h, 10.w, 0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthNumberPage()),
          );
        },
        child: Container(
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(
            left: 20.w,
            right: 25.w,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppRes.enterByPhoneNumber,
                style: AppTextStyles.titleVerySmall.copyWith(
                  color: AppAllColors.lightAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

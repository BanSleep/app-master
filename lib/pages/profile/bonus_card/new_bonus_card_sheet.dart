import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/profile/profile_navigation.dart';
import 'package:cvetovik/widgets/share/line_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewBonusCardSheet extends ConsumerWidget {
  // Переменная, которая проверяет, активирована ли бонусная карта.
  // В зависимости от неё меняется шторка с информацией о бонусной карте.
  final bool isActivated = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 8.h,
              bottom: 36.h,
            ),
            child: LineSheet(),
          ),
          Text(
            AppRes.bonusCard,
            style: AppTextStyles.titleLarge,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 15.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ShaderMask(
                  shaderCallback: (bounds) {
                    if (isActivated) {
                      return LinearGradient(
                              colors: [Colors.white, Colors.white])
                          .createShader(bounds);
                    }
                    // Накладываем прозрачный белый цвет, если карта не активирована.
                    return LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.1)
                      ],
                    ).createShader(bounds);
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        padding: new EdgeInsets.only(
                            top: 16.h, right: 10.w, left: 10.w),
                        child: SizedBox(
                          height: 112.h,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            AppIcons.bonusBg,
                            height: 112.h,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        right: 0.0,
                        top: 26.h,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "",
                            style: AppTextStyles.titleVerySmall.copyWith(
                                color: AppAllColors.commonColorsWhite),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: Positioned.fill(
                          bottom: 14.0.h,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "",
                              style: AppTextStyles.titleVerySmall.copyWith(
                                  color: AppAllColors.commonColorsWhite),
                            ),
                          ),
                        ),
                      ),
                      // TODO: добавить кнопку "Добавить в Apple Wallet"
                    ],
                  ),
                ),
                isActivated
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: ProfileNavigationButton(
                              title: "История начислений",
                              function: () {},
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: ProfileNavigationButton(
                              title: "О бонусной программе",
                              function: () {},
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: ProfileNavigationButton(
                              title: "Активировать пластиковую карту",
                              function: () {},
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: ProfileNavigationButton(
                              title: "История начисления",
                              function: () {},
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: ProfileNavigationButton(
                              title: "О бонусной программе",
                              function: () {},
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

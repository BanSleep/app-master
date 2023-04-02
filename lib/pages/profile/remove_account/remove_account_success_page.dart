import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/helpers/reset_account_state.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RemoveAccountSuccessPage extends StatelessWidget {
  const RemoveAccountSuccessPage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await resetAppState(context);
        return false;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppAllColors.lightAccent,
        ),
        child: Scaffold(
          backgroundColor: AppAllColors.lightAccent,
          body: Stack(
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    AppIcons.order,
                    height: 209.h,
                    width: 209.h,
                  ),
                  Align(
                      child: Text(
                    "Ваш аккаунт\n удалён",
                    style: AppTextStyles.titleVeryLarge
                        .copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 30.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(children: [
                      SizedBox(
                        height: 68.h,
                      ),
                      Center(
                        child: SvgPicture.asset(
                          AppIcons.logoWhite,
                          height: 42.h,
                          width: 36.w,
                        ),
                      ),
                    ]),
                    AppButton(
                      title: "Закрыть",
                      tap: () async {
                        await resetAppState(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

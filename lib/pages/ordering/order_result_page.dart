import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_theme_observer.dart';
import 'package:cvetovik/pages/cart/cart_page.dart';
import 'package:cvetovik/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderResultPage extends StatelessWidget {
  const OrderResultPage(
      {Key? key,
      required this.orderId,
      this.address,
      this.price,
      this.openRootPage = false})
      : super(key: key);
  final int orderId;
  final String? address;
  final String? price;
  final bool openRootPage;

  @override
  Widget build(BuildContext context) {
    var orderNumber = '${AppRes.order} №$orderId';
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => CartPage()),
          (route) => false,
        );
        return true;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppAllColors.lightAccent,
        ),
        child: Scaffold(
          backgroundColor: AppAllColors.lightAccent,
          body: Padding(
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
                  SizedBox(
                    height: 52.h,
                  ),
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
                        AppRes.orderSuccess,
                        style: AppTextStyles.titleVeryLarge
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                      Positioned(
                        bottom: 15.h,
                        child: Text(
                          orderNumber,
                          style: AppTextStyles.titleSmall400
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  if (address != null && address!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Text(
                        address!,
                        style: AppTextStyles.titleSmall400
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (price != null && price!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Text(
                        '$price ${AppRes.shortCurrency}',
                        style: AppTextStyles.titleSmall400
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppRes.orderDetail,
                      style: AppTextStyles.titleSmall.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppRes.inPersonalArea.toLowerCase(),
                            style: AppTextStyles.titleVeryLarge.copyWith(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Center(
                            child: SizedBox(
                                width: 160.w,
                                child: Divider(
                                  height: 2.h,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 36.h,
                    ),
                    AppButton(
                      title: AppRes.ok2,
                      tap: () async {
                        if (openRootPage) {
                          Navigator.popUntil(context,
                              (Route<dynamic> predicate) => predicate.isFirst);
                        } else {
                          Navigator.pop(context);
                        }
                        var style = AppThemeObserver.getUiOverlayStyle();
                        SystemChrome.setSystemUIOverlayStyle(style);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

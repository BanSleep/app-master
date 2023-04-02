import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/pages/cart/models/cart_price_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef AsyncCallbackWithContext = Future<void> Function(BuildContext context);

class CartContentBottomNavBar extends StatelessWidget {
  const CartContentBottomNavBar(
      {Key? key, required this.data, required this.tapAction})
      : super(key: key);
  final CartPriceData data;
  final AsyncCallbackWithContext tapAction;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      color: AppAllColors.commonColorsWhite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0.w),
              child: Text(
                '${data.total} ${AppRes.shortCurrency}',
                style: AppTextStyles.titleLarge,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 38.h, width: 200.w),
              child: ElevatedButton(
                onPressed: () async {
                  await tapAction(context);
                },
                style: AppUi.buttonActionStyle,
                child: Center(
                  child: Text(
                    AppRes.goCheckout,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleVerySmall
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

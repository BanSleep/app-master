import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/pages/cart/models/cart_price_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'discount_row_widget.dart';

class CartDiscountWidget extends StatelessWidget {
  const CartDiscountWidget({
    Key? key,
    required this.data,
  }) : super(key: key);
  final CartPriceData data;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //padding: EdgeInsets.all(15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [AppUi.baseShadow],
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(15.h),
        child: Column(
          children: [
            _getSumWidget(),
            SizedBox(
              height: 15.h,
            ),
            DiscountRowWidget(
                title: AppRes.promoDiscount, value: data.promoCodeDiscount),
            Visibility(
              visible: data.deliveryPrice > 0,
              child: Column(
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  DiscountRowWidget(
                      title: AppRes.deliveryPrice, value: data.deliveryPrice),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            DiscountRowWidget(
                title: AppRes.total2, bold: true, value: data.total),
          ],
        ),
      ),
    );
  }

  Widget _getSumWidget() {
    if (data.summa > 0)
      return Column(
        children: [
          DiscountRowWidget(
              title: AppRes.summaWithoutDiscount, value: data.summa),
          SizedBox(
            height: 15.h,
          ),
          DiscountRowWidget(
              title: AppRes.summaWithDiscount, value: data.sumWithDiscount),
        ],
      );
    else
      return DiscountRowWidget(
          title: AppRes.summaWithoutDiscount, value: data.sumWithDiscount);
  }
}

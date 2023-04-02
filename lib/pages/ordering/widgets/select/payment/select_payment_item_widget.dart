import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/ordering/models/payment_method_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectPaymentItemWidget extends StatelessWidget {
  const SelectPaymentItemWidget(
      {Key? key, required this.data, this.icon, this.onTap})
      : super(key: key);
  final PaymentMethodData? data;
  final Widget? icon;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!(data);
      },
      child: Container(
        width: 300.w,
        height: 66.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  data == null
                      ? SizedBox(
                          width: 36.h,
                          height: 36.h,
                        )
                      : Container(
                          width: 36.h,
                          height: 36.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppAllColors.lightGrey,
                          ),
                          child: _getIcon(),
                        ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.h),
                    child: Text(
                      data != null ? data!.title : AppRes.select,
                      style: AppTextStyles.textMediumBold,
                    ),
                  ),
                ],
              ),
              if (icon != null) icon!,
            ],
          ),
        ),
      ),
    );
  }

  Widget? _getIcon() {
    String? icon;
    final double size = 12.h;
    switch (data!.method) {
      case PaymentMethod.applePay:
        icon = AppIcons.applePay;
        break;
      case PaymentMethod.googlePay:
        break;
      case PaymentMethod.card:
        icon = AppIcons.card;
        break;
      case PaymentMethod.cash:
        icon = AppIcons.cash;
        break;
      case PaymentMethod.youMoney:
        icon = AppIcons.youMoney;
        break;
      case PaymentMethod.payPal:
        icon = AppIcons.paypal;
        break;
    }
    if (icon != null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          icon,
          height: size,
          width: size,
        ),
      );
    }
    return null;
  }
}

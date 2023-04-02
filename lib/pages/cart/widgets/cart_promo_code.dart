/*import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/widgets/app_button.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef AsyncCallbackWithContextAndStr = Future<void> Function(
    BuildContext context, String code);

class CartPromoCode extends StatefulWidget {
  const CartPromoCode({Key? key, required this.callback}) : super(key: key);
  final AsyncCallbackWithContextAndStr callback;

  @override
  State<CartPromoCode> createState() => _CartPromoCodeState();
}

class _CartPromoCodeState extends State<CartPromoCode> {
  @override
  Widget build(BuildContext context) {
    final keyPromo = GlobalKey();

    return Container(
      height: 76.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [AppUi.baseShadow],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppTextField(
              key: keyPromo,
              hint: AppRes.promoCode,
              title: '',
              minLength: 3,
              errorText: AppRes.inputPromoCode,
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          SizedBox(
            width: 59.w,
            child: AppButton(
              white: false,
              title: AppRes.ok,
              tap: () async {
                var promoCode = (keyPromo.currentState! as GetStrMixin).value();
                await widget.callback(context, promoCode);
              },
              rightPad: 0.w,
            ),
          ),
        ],
      ),
    );
  }
}*/

import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/pages/cart/provider/product_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddInCartButton extends ConsumerWidget {
  const AddInCartButton({Key? key, required this.price}) : super(key: key);
  final int price;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: 44.h, width: 189.w),
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(productCartProvider).addToCart();
          var res = ref.refresh(cartListProvider);
          print(res);
          ref.refresh(cartAddProvider);
          Navigator.pop(context);
          AppUi.showToast(context, AppRes.success);
        },
        style: AppUi.buttonActionStyle,
        child: Consumer(
          builder: (BuildContext context, watch, Widget? child) {
            var productCart = ref.watch(cartTitleProvider);
            return Text(
              productCart.actionTitle,
              style: AppTextStyles.titleVerySmall.copyWith(color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}

import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/pages/products/widget/buy_product/add_in_cart_button.dart';
import 'package:cvetovik/pages/products/widget/buy_product/buy_one_click_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuyActionsWidget extends StatelessWidget {
  const BuyActionsWidget({Key? key, required this.price, this.item})
      : super(key: key);
  final int price;
  final ProductData? item;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // BuyOneClickButton(
        //   height: 44.h,
        //   width: 91.w,
        //   item: item,
        // ),

        Expanded(child: AddInCartButton(price: price)),
      ],
    );
  }
}

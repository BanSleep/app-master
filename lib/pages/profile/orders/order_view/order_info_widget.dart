import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/order/order_list_response.dart';
import 'package:cvetovik/pages/profile/orders/order_list/orders_model.dart';
import 'package:cvetovik/pages/profile/orders/order_view/order_view_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';

class OrderInfoWidget extends ConsumerWidget {
  OrderInfoWidget(
    this.order, {
    required this.isShownInList,
  });

  final Order order;
  final bool isShownInList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OrderViewPage(order.id)),
      ).then((value) => ref.read(ordersModelProvider.notifier).reload()),
      child: Card(
        elevation: isShownInList ? 0.0 : 2.0,
        child: Center(
          child: Container(
            width: 280.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: AppAllColors.commonColorsWhite,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 15.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Заказ №" + order.id.toString(),
                          style: AppTextStyles.textMediumBold.copyWith(
                            color: AppAllColors.black,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          order.statusName,
                          style: AppTextStyles.textMediumBold.copyWith(
                            color: HexColor(order.hexStatusColor),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${order.productsCount} товаров",
                      style: AppTextStyles.textMedium9.copyWith(
                        color: AppAllColors.greyBd,
                      ),
                    ),
                    Text(
                      "${order.paymentAmount} ₽",
                      style: AppTextStyles.textMedium9.copyWith(
                        color: AppAllColors.greyBd,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppAllColors.lightAccent,
                  size: 12.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

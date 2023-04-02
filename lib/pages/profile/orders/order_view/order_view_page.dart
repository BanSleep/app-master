import 'package:cached_network_image/cached_network_image.dart';
import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/order/order_view_response.dart';
import 'package:cvetovik/pages/profile/orders/order_view/order_view_model.dart';
import 'package:cvetovik/widgets/scaffold.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:hexcolor/hexcolor.dart';

class OrderViewPage extends ConsumerWidget {
  OrderViewPage(this.orderId);

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderViewModelProvider(orderId));
    return AppScaffold(
      title: state.maybeWhen(
        loaded: (order) => Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "Заказ №$orderId "),
              TextSpan(
                text: order.statusName,
                style: TextStyle(
                  color: HexColor(order.hexStatusColor),
                ),
              ),
            ],
          ),
        ),
        orElse: () => Text("Заказ №$orderId"),
      ),
      body: state.map(
        loaded: (state) => _OrderViewPageBody(state.data),
        error: (state) => AppErrorWidget(
          text: state.text,
          tryAgain: () async {
            await ref.read(orderViewModelProvider(orderId).notifier).load();
          },
        ),
        initializing: (_) => LoadingWidget(),
      ),
    );
  }
}

class _OrderViewPageBody extends StatelessWidget {
  const _OrderViewPageBody(
    this.order, {
    Key? key,
  }) : super(key: key);

  final OrderDetails order;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text("Ожидаемое время доставки")
                        .textStyle(AppTextStyles.textLarge)
                        .textColor(Colors.black),
                  ),
                  Text(order.delivery.date)
                      .textStyle(AppTextStyles.titleVerySmall),
                ],
              ),
            ],
          ),
        ),
        35.0.heightBox,
        _Card(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: order.products.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => Row(
              children: [
                if (order.products[index].image != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: order.products[index].image!,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  ),
                  12.w.widthBox,
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: AppTextStyles.descriptionSmall6.copyWith(
                            color: AppAllColors.black,
                          ),
                          children: [
                            WidgetSpan(
                              child: Image.asset(
                                AppIcons.balls2,
                                width: 10.r,
                                height: 10.r,
                              ),
                            ),
                            WidgetSpan(child: 3.0.widthBox),
                            TextSpan(
                              text: order.products[index].totalBonus.toString(),
                            ),
                          ],
                        ),
                      ),
                      7.h.heightBox,
                      Text(order.products[index].name)
                          .textStyle(AppTextStyles.descriptionMedium)
                          .textColor(Colors.black),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(order.products[index].totalCost.toString() + " ₽")
                        .textStyle(AppTextStyles.textLessMedium
                            .copyWith(fontWeight: FontWeight.w700))
                        .textColor(AppAllColors.black),
                    Text(order.products[index].quantity.toString() + " шт")
                        .textStyle(AppTextStyles.textLessMedium),
                  ],
                ),
              ],
            ),
            separatorBuilder: (_, __) => Divider(),
          ),
        ),
        Text("Всего:")
            .textStyle(AppTextStyles.titleSmall)
            .paddingLTRB(10, 35, 0, 12),
        _Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.products
                              .fold<int>(
                                  0,
                                  (previousValue, element) =>
                                      previousValue + element.quantity)
                              .toString() +
                          " шт товаров",
                    )
                        .textStyle(AppTextStyles.textLarge)
                        .textColor(Colors.black),
                  ),
                  Text(
                    order.products
                            .fold<int>(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.totalCost)
                            .toString() +
                        " ₽",
                  ).textStyle(AppTextStyles.titleVerySmall),
                ],
              ),
              if (order.delivery.price != 0)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Цена доставки",
                      )
                          .textStyle(AppTextStyles.textLarge)
                          .textColor(Colors.black),
                    ),
                    Text(
                      "${order.delivery.price} ₽",
                    ).textStyle(AppTextStyles.titleVerySmall),
                  ],
                ).paddingLTRB(0, 24, 0, 0),
              if (order.usedBonuses > 0) ...[
                Text("Скидка:")
                    .textStyle(AppTextStyles.titleSmall)
                    .textColor(AppAllColors.lightAccent)
                    .paddingLTRB(0, 24, 0, 0),
                Row(
                  children: [
                    Expanded(
                      child: Text("Бонусы")
                          .textStyle(AppTextStyles.textLarge)
                          .textColor(AppAllColors.lightAccent),
                    ),
                    Text("-${order.usedBonuses} ₽")
                        .textStyle(AppTextStyles.titleVerySmall)
                        .textColor(AppAllColors.lightAccent),
                  ],
                ).paddingLTRB(0, 12, 0, 0),
              ],
              Text("Итого:")
                  .textStyle(AppTextStyles.titleSmall)
                  .paddingLTRB(0, 24, 0, 0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.products
                              .fold<int>(
                                  0,
                                  (previousValue, element) =>
                                      previousValue + element.quantity)
                              .toString() +
                          " шт товаров",
                    )
                        .textStyle(AppTextStyles.textLarge)
                        .textColor(Colors.black),
                  ),
                  Text(
                    "${order.paymentAmount} ₽",
                  ).textStyle(AppTextStyles.titleVerySmall),
                ],
              ).paddingLTRB(0, 12, 0, 0),
              if (order.products.fold<int>(
                      0,
                      (previousValue, element) =>
                          previousValue + element.totalBonus) >
                  0)
                Row(
                  children: [
                    Expanded(
                      child: Text("Получено")
                          .textStyle(AppTextStyles.textLarge)
                          .textColor(Colors.black),
                    ),
                    Text(
                      order.products
                              .fold<int>(
                                  0,
                                  (previousValue, element) =>
                                      previousValue + element.totalBonus)
                              .toString() +
                          " бонусов",
                    ).textStyle(AppTextStyles.titleVerySmall),
                  ],
                ).paddingLTRB(0, 12, 0, 0),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            style: AppTextStyles.titleSmall,
            children: [
              TextSpan(text: "Способ получения: "),
              TextSpan(
                text: (order.delivery.type == DeliveryType.delivery
                    ? "доставка"
                    : "самовывоз"),
                style: TextStyle(color: AppAllColors.lightAccent),
              ),
            ],
          ),
        ).paddingLTRB(10, 35, 0, 12),
        _Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.delivery.type == DeliveryType.delivery
                    ? "Адрес доставки"
                    : "Адрес магазина",
              ).textStyle(AppTextStyles.textMediumBold).textColor(Colors.black),
              2.h.heightBox,
              Text(
                order.delivery.address,
              ).textStyle(AppTextStyles.textLessMedium).textColor(Colors.black),
            ],
          ),
        ),
        10.h.heightBox,
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: AppAllColors.commonColorsWhite,
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: child,
      ),
    );
  }
}

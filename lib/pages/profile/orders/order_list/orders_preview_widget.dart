import 'package:cvetovik/models/api/response/order/order_list_response.dart';
import 'package:cvetovik/pages/profile/orders/order_view/order_info_widget.dart';
import 'package:cvetovik/pages/profile/orders/order_list/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersPreviewWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ordersModelProvider);
    return state.maybeMap(
      loaded: (state) => _OrdersPreviewWidgetBody(state.data),
      orElse: () => SizedBox(),
    );
  }
}

class _OrdersPreviewWidgetBody extends StatelessWidget {
  const _OrdersPreviewWidgetBody(
    this.orders, {
    Key? key,
  }) : super(key: key);

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.h,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(15),
        itemCount: orders.length > 3 ? 3 : orders.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: ((_, index) {
          return Column(
            children: [
              OrderInfoWidget(
                orders[index],
                isShownInList: false,
              )
            ],
          );
        }),
      ),
    );
  }
}

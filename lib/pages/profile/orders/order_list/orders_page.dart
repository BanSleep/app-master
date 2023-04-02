import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/models/api/response/order/order_list_response.dart';
import 'package:cvetovik/pages/profile/orders/order_view/order_info_widget.dart';
import 'package:cvetovik/pages/profile/orders/order_list/orders_model.dart';
import 'package:cvetovik/widgets/scaffold.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awesome_extensions/awesome_extensions.dart';

class OrdersPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ordersModelProvider);
    return AppScaffold(
      title: Text("Мои заказы"),
      body: state.map(
        loaded: (state) => _OrdersPageBody(state.data),
        emptyData: (_) => Center(child: Text("У вас нет заказов")),
        error: (state) => AppErrorWidget(
          text: state.text,
          tryAgain: () async {
            await ref.read(ordersModelProvider.notifier).load();
          },
        ),
        initializing: (_) => LoadingWidget(),
      ),
    );
  }
}

class _OrdersPageBody extends StatelessWidget {
  const _OrdersPageBody(
    this.orders, {
    Key? key,
  }) : super(key: key);

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: AppAllColors.commonColorsWhite,
        elevation: 2.0,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: orders.length,
          itemBuilder: ((_, index) {
            return OrderInfoWidget(
              orders[index],
              isShownInList: true,
            );
          }),
          separatorBuilder: (_, __) => Divider(
            color: AppAllColors.lightGrey,
            thickness: 1,
          ).paddingSymmetric(horizontal: 50),
        ),
      ),
    );
  }
}

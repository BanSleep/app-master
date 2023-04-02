import 'package:collection/collection.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/cart/provider/product_cart_provider.dart';
import 'package:cvetovik/pages/products/models/count_info.dart';
import 'package:cvetovik/widgets/product/counter/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'counter_step.dart';

class ProductCounterWidget extends ConsumerStatefulWidget {
  final int price;
  const ProductCounterWidget({Key? key, required this.price}) : super(key: key);

  @override
  _ProductCounterWidgetState createState() => _ProductCounterWidgetState();
}

class _ProductCounterWidgetState extends ConsumerState<ProductCounterWidget> {
  bool isBouquet() {
    bool res = widget.price > 300;
    return res;
  }

  @override
  Widget build(BuildContext context) {
    List<CountInfo> steps = [
      CountInfo(count: 15),
      CountInfo(count: 25),
      CountInfo(count: 55),
      CountInfo(count: 101)
    ];
    var cartTitleProv = ref.read(cartTitleProvider.notifier);
    if (cartTitleProv.state.versions != null &&
        cartTitleProv.state.versions!.length > 0) {
      if (cartTitleProv.state.versions!.length == 1) {
        var curr = cartTitleProv.state.versions!.first;
        steps = curr.prices
            .map(
              (e) => CountInfo(
                  count: e.minNum,
                  desc: '${AppRes.by} ${e.price}${AppRes.shortCurrency}'),
            )
            .where((element) => element.count > 0)
            .toList();
      } else {
        var curr = cartTitleProv.state.versions!.firstWhereOrNull(
            (element) => element.title == cartTitleProv.state.versionTitle);
        if (curr != null) {
          steps = curr.prices
              .map(
                (e) => CountInfo(
                    count: e.minNum,
                    desc: '${AppRes.by} ${e.price}${AppRes.shortCurrency}'),
              )
              .where((element) => element.count > 0)
              .toList();
        }
      }
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Text(
              //(isBouquet()) ? AppRes.countBouquet : AppRes.count,
              AppRes.count,
              style: AppTextStyles.titleVerySmall,
              textAlign: TextAlign.start,
            ),
          ),
          Visibility(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: steps.map((e) {
                  return CounterStep(
                    step: e,
                    onTap: (value) {
                      ref
                          .read(productCartProvider)
                          .updateCountByNewValue(value);
                    },
                  );
                }).toList(),
              ),
            ),
            visible: !isBouquet(),
          ),
          Container(
            padding: EdgeInsets.all(4.0.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12.r))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CounterButton(
                    onTap: () {
                      ref.read(productCartProvider).updateCountByStep(false);
                    },
                    icon: Icons.remove,
                  ),
                  Consumer(
                    builder: (BuildContext context, watch, Widget? child) {
                      final counter = ref.watch(cartTitleProvider);
                      return Text(
                        counter.count.toString(),
                        style: AppTextStyles.title22,
                      );
                    },
                  ),
                  CounterButton(
                    onTap: () {
                      ref.read(productCartProvider).updateCountByStep(true);
                    },
                    icon: Icons.add,
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}

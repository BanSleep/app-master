import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/models/app/nav_data.dart';
import 'package:cvetovik/pages/cart/cart_content.dart';
import 'package:cvetovik/pages/cart/models/cart_row_add_data.dart';
import 'package:cvetovik/pages/cart/widgets/cart_empty_widget.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:cvetovik/widgets/tab_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends StatefulWidget {
  final NavData? navKey;

  const CartPage({Key? key, this.navKey}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

   CartRowAddData? mainData;

  Future<CartRowAddData> _getAddItems(List<int> ids, WidgetRef ref1) async {
    var cartProvider = ref1.read(cartDaoProvider);
    var add = await cartProvider.getAddItems();
    var favProv = ref1.read(favoritesDaoProvider);
    var favItems = await favProv.getItemsForCart(ids);
    return CartRowAddData(add, favItems);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return TabRoot(
      Material(
        child: Consumer(
          builder: (BuildContext context, ref, _) {
            var list = ref.watch(cartListProvider);
            return list.when(
                data: (List<CartMainData> data) {
                  if (data.isEmpty) {
                    return CartEmptyWidget();
                  } else {
                    var ids = data.map((e) => e.productId).toList();
                    return FutureBuilder<CartRowAddData>(
                      future: _getAddItems(ids, ref),
                      builder: (BuildContext context,
                          AsyncSnapshot<CartRowAddData> snapshot) {
                        if (snapshot.hasData) {
                          return CartContent(
                              mainData: data, addData: snapshot.data!);
                        } else {
                          return LoadingWidget();
                        }
                        ;
                      },
                    );
                  }
                },
                loading: () => LoadingWidget(),
                error: (error, stackTrace) => AppErrorWidget(
                      text: AppRes.error,
                      tryAgain: () async {},
                    ));
          },
        ),
      ),
      navData: widget.navKey,
    );
  }
}

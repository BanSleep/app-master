import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/app/nav_data.dart';
import 'package:cvetovik/pages/favorites/favorites_content.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:cvetovik/widgets/tab_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'favorite_empty_widget.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key, this.navKey}) : super(key: key);
  final NavData? navKey;

  @override
  Widget build(BuildContext context) {
    return TabRoot(
      Scaffold(
        body: Consumer(
          builder: (context, ref, _) {
            var list = ref.watch(favoriteListProvider);
            return list.when(
                data: (List<FavoriteData> data) {
                  if (data.isEmpty) {
                    return FavoriteEmptyWidget();
                  } else {
                    var items = data
                        .map((e) => ProductData(courierPayments: [],

                            id: e.id,
                            averageMark: e.averageMark,
                            badges: e.badges,
                            bonus: e.bonus,
                            image: e.image,
                            maxPrice: e.maxPrice,
                            price: e.price,
                            priceTime: e.priceTime,
                            regularPrice: e.regularPrice,
                            title: e.title,
                            sku: e.sku, pickUpPayments: []))
                        .toList();
                    return FavoritesContent(
                      title: AppRes.favorites,
                      items: items,
                    );
                  }
                },
                loading: _loading,
                error: _onError);
          },
        ),
      ),
      navData: navKey,
    );
  }

  Widget _loading() {
    return LoadingWidget();
  }

  Widget _onError(Object error, StackTrace? stackTrace) {
    return AppErrorWidget(
      text: AppRes.error,
      tryAgain: () async {},
    );
  }
}

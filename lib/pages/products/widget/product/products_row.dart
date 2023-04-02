import 'package:collection/collection.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/api/response/region/region_info_response.dart';
import 'package:cvetovik/pages/products/widget/product/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsRow extends StatelessWidget {
  const ProductsRow(
      {Key? key,
      required this.items,
      this.isFavorite = false,
      this.favorites,
      this.promos})
      : super(key: key);
  final List<ProductData> items;
  final bool isFavorite;
  final List<FavoriteData>? favorites;
  final Promos? promos;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0.h),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items
              .map((e) => ProductItemWidget(
                    item: e,
                    favorite: _getFavorite(e.id),
                    width: 145.0.w,
                    promos: promos,
                  ))
              .toList(),
        ),
      ),
    );
  }

  bool _getFavorite(int id) {
    if (isFavorite) {
      return true;
    } else {
      if (favorites != null) {
        var curr = favorites!.firstWhereOrNull((el) => el.id == id);
        var res = (curr != null);
        return res;
      } else {
        return false;
      }
    }
  }
}

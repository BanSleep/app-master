import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/api/response/region/region_info_response.dart';
import 'package:cvetovik/pages/products/widget/product/products_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiver/iterables.dart';

class FavoritesContent extends StatelessWidget {
  const FavoritesContent(
      {Key? key, required this.title, required this.items, this.info})
      : super(key: key);

  final String title;
  final List<ProductData> items;
  //TODO add RegionInfo
  final RegionInfo? info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppUi.pagePadding,
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 18.h),
            child: Text(title, style: AppTextStyles.titleLarge),
          ),
        ),
        _getItems(),
      ]),
    );
  }

  Widget _getItems() {
    var rows = partition(items, 2);
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: rows
            .map((e) => ProductsRow(
                  items: e,
                  isFavorite: _getFavorite(),
                ))
            .toList(),
      ),
    );
  }

  bool _getFavorite() {
    return true;
  }
}

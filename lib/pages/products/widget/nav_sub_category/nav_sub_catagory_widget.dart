import 'package:cvetovik/pages/catalog/models/catalog_second_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'nav_sub_category_item_widget.dart';

class NavSubCategoryWidget extends StatelessWidget {
  const NavSubCategoryWidget(
      {Key? key, required this.secondItems, required this.productId})
      : super(key: key);
  final List<CatalogSecondData> secondItems;
  final int productId;
  @override
  Widget build(BuildContext context) {
    var filterSecondItems =
        secondItems.where((el) => el.id != productId).toList();
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterSecondItems.length,
        itemBuilder: (context, index) {
          var item = filterSecondItems[index];
          return NavSubCategoryItemWidget(item: item, secondItems: secondItems);
        },
        shrinkWrap: true,
      ),
    );
  }
}

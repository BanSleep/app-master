import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/catalog_response.dart';
import 'package:cvetovik/pages/catalog/models/catalog_second_data.dart';
import 'package:cvetovik/pages/catalog/widget/catalog_second_item_widget.dart';
import 'package:cvetovik/widgets/app_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiver/iterables.dart';

import 'catalog_row_widget.dart';

// ignore: must_be_immutable
class CatalogContent extends StatelessWidget {
  CatalogContent(
      {Key? key,
      required this.title,
      required this.parentId,
      required this.items})
      : super(key: key);
  final String title;
  final int parentId;
  final List<CatalogData> items;

  int relevantRegion = 0;

  @override
  Widget build(BuildContext context) {
    var column = Padding(
        padding: AppUi.pagePadding,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 19.h, top: 0.h),
                  child: Text(
                    title,
                    style: AppTextStyles.titleSmall,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            _getItems(context)
          ],
        ));

    if (parentId == 0)
      return SingleChildScrollView(
        child: column,
      );
    else {
      return column;
    }
  }

  Widget _getItems(context) {
    if (parentId == 0) {
      var rows = partition(items, 3);

      return Column(
        children: rows
            .map((e) => CatalogRowWidget(
                  items: e,
                ))
            .toList(),
      );
    } else {
      return _getItemsSecondLevel();
    }
  }

  Widget _getItemsSecondLevel() {
    List<CatalogSecondData> secondItems = [];
    secondItems.add(CatalogSecondData(
        id: parentId, title: AppRes.allProductByCategory, isFirst: true));
    var subItems = items
        .map((element) => CatalogSecondData(
            id: element.id,
            title: element.title,
            count: element.productsNum,
            image: element.image))
        .toList();
    secondItems.addAll(subItems);
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(bottom: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          AppUi.baseShadow,
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, top: 5.w),
        child: ListView.separated(
          itemCount: secondItems.length,
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(left: 10.w, right: 40.w),
              child: AppDivider(),
            );
          },
          itemBuilder: (BuildContext context, int index) {
            var item = secondItems[index];
            return CatalogSecondItemWidget(
              secondItems: subItems,
              data: item,
            );
          },
        ),
      ),
    ));
  }
}

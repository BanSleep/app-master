import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/catalog/models/catalog_second_data.dart';
import 'package:cvetovik/pages/products/products_page.dart';
import 'package:cvetovik/pages/products/widget/nav_sub_category/subcategory_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavSubCategoryItemWidget extends StatelessWidget {
  const NavSubCategoryItemWidget(
      {Key? key, required this.item, required this.secondItems})
      : super(key: key);
  final CatalogSecondData item;
  final List<CatalogSecondData> secondItems;
  @override
  Widget build(BuildContext context) {
    var title = item.title.replaceFirst(' ', '\n');
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductsPage(
                    title: item.title,
                    productId: item.id,
                    count: item.count,
                    secondItems: secondItems,
                  )),
        );
      },
      child: Container(
        height: 40.h,
        padding: EdgeInsets.only(right: 15.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //'https://cvetovik.com/pics/types/app/44.png'
            SubcategoryImageItemWidget(source: item.image),
            Padding(
              padding: EdgeInsets.only(left: 12.0.h),
              child: Text(
                title,
                style: AppTextStyles.descriptionMedium10Black,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

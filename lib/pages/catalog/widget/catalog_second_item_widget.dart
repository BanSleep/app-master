import 'package:cvetovik/core/services/providers/catalog_id_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/catalog/models/catalog_second_data.dart';
import 'package:cvetovik/pages/products/products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CatalogSecondItemWidget extends ConsumerWidget {
  const CatalogSecondItemWidget(
      {Key? key, required this.data, required this.secondItems})
      : super(key: key);

  final CatalogSecondData data;
  final List<CatalogSecondData> secondItems;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var style = AppTextStyles.textMediumBold.copyWith(color: Colors.black);
    if (data.isFirst) {
      style = style.copyWith(color: AppAllColors.lightAccent);
    }
    return InkWell(
      onTap: () {
        var idProvider = ref.read(catalogIdProvider);
        idProvider.id = data.id;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductsPage(
                    title: data.title,
                    productId: data.id,
                    count: data.count,
                    secondItems: secondItems,
                  )),
        );
      },
      child: Container(
        height: 54.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: style,
                ),
                _getCount(style),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppAllColors.lightAccent,
                size: 12.w,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getCount(TextStyle style) {
    if (data.count != null && data.count!.isNotEmpty) {
      var currStyle = AppTextStyles.textMediumBold
          .copyWith(color: AppAllColors.lightAccent);
      return Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: Text('(${data.count})', style: currStyle),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

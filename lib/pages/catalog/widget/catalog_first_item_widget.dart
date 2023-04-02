import 'package:cached_network_image/cached_network_image.dart';
import 'package:cvetovik/core/services/providers/catalog_id_provider.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/catalog_response.dart';
import 'package:cvetovik/pages/catalog/catalog_page.dart';
import 'package:cvetovik/pages/products/products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CatalogFirstItemWidget extends ConsumerWidget {
  final CatalogData item;
  const CatalogFirstItemWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (item.isGroup) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CatalogPage(title: item.title, parentId: item.id)),
          );
        } else {
          var idProvider = ref.read(catalogIdProvider);
          idProvider.id = item.id;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductsPage(title: item.title, productId: item.id)),
          );
        }
      },
      child: Column(
        children: [
          Container(
            width: 87.h,
            height: 87.h,
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19.r),
              boxShadow: [
                AppUi.baseShadow,
              ],
              color: Colors.white,
            ),
            child: _getImage(item),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: Text(
              _breakTitle(item.title),
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppTextStyles.textMedium,
            ),
          )
        ],
      ),
    );
  }

  Widget _getImage(CatalogData item) {
    if (item.image != null)
      return Center(
        child: CachedNetworkImage(
          imageUrl: item.image!,
          height: 43.h,
        ),
      );
    else {
      return SizedBox.shrink();
    }
  }

  String _breakTitle(String title) {
    var newTitle = title.trim().replaceFirst(' ', '\n');
    return newTitle;
  }
}

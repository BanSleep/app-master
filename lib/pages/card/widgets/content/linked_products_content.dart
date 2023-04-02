import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/linked/linked_products_response.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/pages/obj_id.dart';
import 'package:cvetovik/pages/card/widgets/content/segment/segment_category_widget.dart';
import 'package:cvetovik/pages/products/products_page.dart';
import 'package:cvetovik/pages/products/widget/product/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LinkedProductsContent extends StatefulWidget {
  const LinkedProductsContent({Key? key, this.linkedProducts})
      : super(key: key);
  final Map<String, LinkedProduct>? linkedProducts;

  @override
  _LinkedProductsContentState createState() => _LinkedProductsContentState();
}

class _LinkedProductsContentState extends State<LinkedProductsContent> {
  List<ProductData>? currentItems;

  late LinkedProduct? currProduct;

  @override
  void initState() {
    currProduct = widget.linkedProducts!.values.first;
    currentItems = widget.linkedProducts!.values.first.products.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ObjId> titles = [];
    widget.linkedProducts!.values.forEach((el) {
      titles.add(ObjId(el.id.toString(), el.title));
    });
    int catalogId = (currProduct != null) ? currProduct!.id : 0;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppRes.buyWithThisProduct,
                  textAlign: TextAlign.start, style: AppTextStyles.titleSmall),
              InkWell(
                  onTap: () async {
                    if (currProduct != null)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductsPage(
                                  title: currProduct!.title,
                                  productId: currProduct!.id,
                                )),
                      );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Color(0xffe9ffed),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(AppRes.catalog,
                            style: AppTextStyles.descriptionMediumBold),
                        SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: AppAllColors.lightAccent,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          SegmentCategoryWidget(
            items: titles,
            onUpdated: _categoryUpdated,
          ),
          Container(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: (currentItems != null)
                  ? [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: currentItems!
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                      bottom: 10,
                                    ),
                                    child: ProductItemWidget(
                                      item: e,
                                      width: 134.w,
                                      addCatalogId: catalogId,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ]
                  : [],
            ),
          )
        ],
      ),
    );
  }

  void _categoryUpdated(String key) {
    setState(() {
      currProduct = widget.linkedProducts![key];
      if (currProduct != null) {
        currentItems = currProduct!.products.values.toList();
      }
      print(key);
    });
  }
}

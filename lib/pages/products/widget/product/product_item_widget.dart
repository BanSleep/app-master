import 'package:cached_network_image/cached_network_image.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/providers/catalog_id_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/api/response/region/region_info_response.dart';
import 'package:cvetovik/pages/card/product_card_page.dart';
import 'package:cvetovik/pages/products/widget/buy_product/show_cart_sheet_button.dart';
import 'package:cvetovik/pages/products/widget/content/fav_icon.dart';
import 'package:cvetovik/widgets/product/badges/product_badges_helper.dart';
import 'package:cvetovik/widgets/product/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';

class ProductItemWidget extends ConsumerWidget {
  const ProductItemWidget(
      {Key? key,
      required this.item,
      this.promos,
      this.favorite = false,
      required this.width,
      this.addCatalogId = 0})
      : super(key: key);
  final ProductData item;
  final Promos? promos;
  final bool favorite;
  final double width;
  final int addCatalogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _unescape = HtmlUnescape();
    var badges = ProductsBadgesHelper(item.bonus, item.badges, promos);
    //final double width = 145.0.w;
    final double radius = 9.24.r;
    return InkWell(
      onTap: () async {
        //TODO test it
        if (addCatalogId > 0) {
          var catalogIdProv = ref.read(catalogIdProvider);
          catalogIdProv.addId = catalogIdProv.id;
          catalogIdProv.id = addCatalogId;
        }
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductCardPage(
                    item: item,
                    favorite: favorite,
                  )),
        ).then((value) {
          //TODO check1
          //var catalogIdProv = ref.read(catalogIdProvider);
          //catalogIdProv.restore();
        });
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [AppUi.baseShadow],
          color: Colors.white,
        ),
        padding: EdgeInsets.only(
          bottom: 8.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(radius),
                        topRight: Radius.circular(radius)),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        CachedNetworkImage(
                          imageUrl: item.image,
                          height: 119.h,
                          width: width,
                          fit: BoxFit.fill,
                        ),
                        if (item.averageMark != null && item.averageMark! > 0)
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15.w),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4.r),
                                      topRight: Radius.circular(4.r),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                    ),
                                    color: Colors.white,
                                  ),
                                  height: 12.h,
                                  width: 26.w,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3, right: 2),
                                          child: Icon(Icons.star,
                                              size: 8.h,
                                              color: AppAllColors
                                                  .commonColorsYellow),
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(
                                        item.averageMark!.toString(),
                                        style: AppTextStyles.descriptionSmall6,
                                      )),
                                    ],
                                  ),
                                ),
                              )),
                      ],
                    )),
                Align(
                  alignment: Alignment.topLeft,
                  child: badges.getActions(),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: FavIcon(
                      item: item,
                      selected: favorite,
                    )),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 11.71.h),
                      child: Text(
                        _unescape.convert(item.title),
                        maxLines: 4,
                        overflow: TextOverflow.fade,
                        style: AppTextStyles.textMedium,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    badges.getBadgesWithBonus(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _getRegularPrice(context, item.regularPrice),
                        PriceWidget(
                          price: item.price,
                          maxPrice: item.maxPrice,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0.h),
                      child: ShowCartSheetButton(
                        item: item,
                        height: 25.97.h,
                        initProv: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getRegularPrice(context, int regularPrice) {
    return Padding(
      padding: EdgeInsets.only(
          left: 0, right: (regularPrice != 0) ? 5.w : 0, bottom: 8.h, top: 8.h),
      child: (regularPrice != 0)
          ? Padding(
              padding: EdgeInsets.only(right: 2.0.w),
              child: Text(
                '$regularPrice ${AppRes.shortCurrency}',
                style: AppTextStyles.textRegularPrice,
              ),
            )
          : SizedBox.shrink(),
    );
  }
}

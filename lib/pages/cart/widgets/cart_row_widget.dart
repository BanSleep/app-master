import 'package:cached_network_image/cached_network_image.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/services/providers/catalog_data_provider.dart';
import 'package:cvetovik/core/services/providers/catalog_id_provider.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/card/product_card_page.dart';
import 'package:cvetovik/pages/cart/models/row_provider_data.dart';
import 'package:cvetovik/pages/cart/provider/cart_row_model.dart';
import 'package:cvetovik/pages/cart/provider/product_cart_provider.dart';
import 'package:cvetovik/pages/cart/widgets/count_action_widget.dart';
import 'package:cvetovik/widgets/dialog/platform_dialog.dart';
import 'package:cvetovik/widgets/product/badges/product_badges_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quiver/iterables.dart';

class CartRowWidget extends ConsumerStatefulWidget {
  const CartRowWidget(
      {Key? key, required this.main, this.add, required this.favorite})
      : super(key: key);
  final CartMainData main;
  final List<CartAddData>? add;
  final bool favorite;

  @override
  _CartRowWidgetState createState() => _CartRowWidgetState();
}

class _CartRowWidgetState extends ConsumerState<CartRowWidget> {
  late int sum = 0;
  late ProductsBadgesHelper badges;
  late CartRowModel _rowProvider;
  @override
  void initState() {
    _rowProvider = CartRowModel(
      RowProviderData(widget.main, widget.add),
      ref.read(cartDaoProvider),
    );
    sum = _rowProvider.getSum();
    badges = ProductsBadgesHelper(widget.main.bonus, widget.main.badges, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double size = 52.h;
    return Slidable(
      groupTag: '1',
      key: ValueKey(widget.main.id),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              await PlatformDialog.show(
                  context: context,
                  okTitle: AppRes.delete,
                  action: () async {
                    await _rowProvider.deleteProduct();
                  },
                  droidTitle: '${AppRes.delete} ${widget.main.title}?');
            },
            backgroundColor: AppAllColors.commonColorsRed,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: AppRes.delete,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () async {
              var catalogData = ref.read(catalogDataProvider);
              var catalogId = ref.read(catalogIdProvider);
              if (catalogId.id == 0) {
                catalogId.id = widget.main.catalogId;
              }
              var productItem = await catalogData.getProductData(
                  widget.main.productId, widget.main.catalogId);
              if (productItem != null) {
                if (widget.main.versionTitle != null &&
                    widget.main.versionTitle!.isNotEmpty) {
                  var cartTitleProv = ref.read(cartTitleProvider.notifier);
                  cartTitleProv.state = cartTitleProv.state.copyWith(
                      versionTitle: widget.main.versionTitle,
                      versions: widget.main.versions);
                  var productCartProv = ref.read(productCartProvider);
                  productCartProv.updateTitle();
                }
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductCardPage(
                            item: productItem,
                            alreadyInCart: true,
                            favorite: widget.favorite,
                          )),
                );
              }
            },
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 12.w),
                  child: CachedNetworkImage(
                    imageUrl: widget.main.image,
                    height: size,
                    width: size,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                //title
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getBadges(),
                    Container(
                      width: 118.w,
                      child: Text(widget.main.title,
                          maxLines: 3,
                          style: AppTextStyles.descriptionMedium
                              .copyWith(color: AppAllColors.lightBlack)),
                    ),
                    if (widget.add != null) _getAddProducts()
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0.w),
            child: Container(
              width: 70.78.w,
              height: 64.24.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                      visible: widget.main.regularPrice > 0,
                      child: Text(
                          '${widget.main.regularPrice * widget.main.count} ${AppRes.shortCurrency}',
                          style: AppTextStyles.descriptionMedium.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ))),
                  Text('$sum ${AppRes.shortCurrency}',
                      style: AppTextStyles.textLessMediumBold
                          .copyWith(color: AppAllColors.lightBlack)),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CountActionWidget(
                          tapAction: () async {
                            var tmpSum = await _rowProvider.decCount();
                            if (tmpSum > 0) {
                              setState(() {
                                sum = tmpSum;
                              });
                            }
                          },
                          iconData: Icons.remove,
                        ),
                        Center(
                          child: Text(_rowProvider.count.toString(),
                              style: AppTextStyles.titleVerySmall),
                        ),
                        CountActionWidget(
                          tapAction: () async {
                            int newSum = await _rowProvider.incCount();
                            setState(() {
                              sum = newSum;
                            });
                          },
                          iconData: Icons.add,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBadges() {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: badges.getBadgesWithBonus(isSmall: true),
    );
  }

  Widget _getAddProducts() {
    final double size = 20.r;
    List<Widget> rawChildren = widget.add!
        .map((e) => Padding(
              padding: EdgeInsets.only(right: 6.0.w),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  border: Border.all(color: AppAllColors.iconsWhite2, width: 1),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    imageUrl: e.image,
                  ),
                ),
              ),
            ))
        .toList();
    var items = partition(rawChildren, 5).toList();
    List<Widget> children = [];
    items.forEach((el) {
      children.add(Row(
        children: el,
      ));
    });

    return Column(
      children: children,
    );
  }
}

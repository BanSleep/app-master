import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/api/response/region/region_info_response.dart';
import 'package:cvetovik/pages/catalog/models/catalog_second_data.dart';
import 'package:cvetovik/pages/products/models/enum/product_badges.dart';
import 'package:cvetovik/pages/products/widget/filter/actions_filter_widget.dart';
import 'package:cvetovik/pages/products/widget/filter/filter_button.dart';
import 'package:cvetovik/pages/products/widget/header/sliver_persistant_widget.dart';
import 'package:cvetovik/pages/products/widget/nav_sub_category/nav_sub_catagory_widget.dart';
import 'package:cvetovik/pages/products/widget/product/products_row.dart';
import 'package:cvetovik/widgets/product/title_with_up_item_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:quiver/iterables.dart';

class ProductsContent extends StatefulWidget {
  const ProductsContent({
    Key? key,
    required this.title,
    required this.items,
    required this.productId,
    this.filterCallback,
    this.bannerText,
    this.sortCallback,
    this.filterIsSelected = false,
    this.count,
    this.info,
    this.favorites,
    this.secondItems,
  }) : super(key: key);

  final String title;
  final String? bannerText;
  final int productId;
  final List<ProductData> items;
  final AsyncCallback? filterCallback;
  final AsyncCallback? sortCallback;
  final bool filterIsSelected;
  final String? count;
  final RegionInfo? info;
  final List<FavoriteData>? favorites;
  final List<CatalogSecondData>? secondItems;

  @override
  State<ProductsContent> createState() => _ProductsContentState();
}

class _ProductsContentState extends State<ProductsContent> {
  late List<ProductData> currItems;

  @override
  void initState() {
    currItems = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppUi.pagePadding,
      child: Column(
        children: [
          _getTitle(),
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [

                  SliverAppBar(
                    leading: SizedBox(),
                    pinned: false,
                    toolbarHeight: 112,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getNavSubCategory(),
                          _getActions(),
                        ],
                      ),
                    ),
                  ),
                  _getBannerText(),
                ];
              },
              body: _getItems(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getNavSubCategory() {
    if (widget.secondItems != null) {
      return NavSubCategoryWidget(
        secondItems: widget.secondItems!,
        productId: widget.productId,
      );
    } else
      return SizedBox(
        height: 10.h,
      );
  }

  Widget _getActions() {
    var items = _getActionItems();
    // print("items from get action items: ${items}");
    return ActionsFilterWidget(
      items: items,
      onActionUpdate: _onActionUpdate,
    );
  }

  Widget _getBannerText() {
    return widget.bannerText != null && widget.bannerText!.isNotEmpty
        ? SliverPersistentHeader(pinned: true,floating: false,
            delegate: SliverPersitantWidget(
                child: Container(
              margin: EdgeInsets.only(bottom: 24),
              color: Color(0xffF6F6F6),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              child: SingleChildScrollView(
                  child: HtmlWidget(widget.bannerText!)),
            )),
          )
        : SliverToBoxAdapter();
  }

  Widget _getTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: TitleWithUpItemWidget(
            title: widget.title,
            count: widget.count,
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilterButton(
                icon: AppIcons.filter,
                isSelected: widget.filterIsSelected,
                tapCallback: widget.filterCallback!,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: FilterButton(
                  icon: AppIcons.sort,
                  tapCallback: widget.sortCallback!,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<ProductBadges> _getActionItems() {
    List<ProductBadges> actions = [];
    var badges = widget.items
        .where((el) => el.badges != null && el.badges!.isNotEmpty)
        .map((e) => e.badges)
        .toList();
    List<String> rawBadges = [];
    if (badges.isNotEmpty) {
      badges.forEach((el) {
        if (el != null) {
          el.forEach((e) {
            // print("raw badge $e");
            var x = (e == "new" ? "newItem" : e);
            rawBadges.add(x);
          });
        }
      });
      if (rawBadges.isNotEmpty) {
        var rawActions = rawBadges
            .toSet()
            .map((e) => EnumToString.fromString(ProductBadges.values, e))
            .toList();
        // print("raw badges : ${rawBadges.toSet()}");
        if (rawActions.isNotEmpty) {
          rawActions.forEach((a) {
            if (a != null) {
              actions.add(a);
            }
          });
        }
      }
    }
    // print("badges in procuts_content / _getActionItems(): ${actions}");
    return actions;
  }

  Widget _getItems() {
    var rows = partition(currItems, 2);
    return ListView(
      children:
        rows
            .map((e) => ProductsRow(
                  items: e,
                  favorites: widget.favorites,
                  promos: (widget.info != null) ? widget.info!.promos : null,
                ))
            .toList()
      ,
    );
  }

  _onActionUpdate(List<ProductBadges> badges) {
    setState(() {
      if (badges.length > 0) {
        List<ProductData> newItems = [];
        var keyItems = badges
            .map((e) => (e == ProductBadges.newItem
                ? "new"
                : EnumToString.convertToString(e)))
            .toList();

        var itemsWithBadges = widget.items
            .where((el) => el.badges != null && el.badges!.length > 0)
            .toList();

        itemsWithBadges.forEach((el) {
          if (el.badges!.any((item) => keyItems.contains(item))) {
            newItems.add(el);
          }
        });
        currItems = newItems;
      } else {
        currItems = widget.items;
      }
    });
  }
}

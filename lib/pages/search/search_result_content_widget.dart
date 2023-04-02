import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/pages/products/widget/filter/filter_button.dart';
import 'package:cvetovik/pages/products/widget/product/products_row.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiver/iterables.dart';

class SearchResultContentWidget extends ConsumerStatefulWidget {
  const SearchResultContentWidget(
      {Key? key,
      required this.data,
      required this.sortCallback,
      required this.search,
      required this.favorites})
      : super(key: key);
  final List<ProductData> data;
  final String search;
  final AsyncCallback sortCallback;
  final List<FavoriteData>? favorites;
  @override
  ConsumerState createState() => _SearchResultContentWidgetState();
}

class _SearchResultContentWidgetState
    extends ConsumerState<SearchResultContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppUi.pagePadding,
      child: Column(
        children: [_getTitle(), _getItems()],
      ),
    );
  }

  Widget _getItems() {
    var rows = partition(widget.data, 2);
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: rows
            .map((e) => ProductsRow(
                  items: e,
                  favorites: widget.favorites,
                  //promos: (widget.info != null) ? widget.info!.promos : null,
                ))
            .toList(),
      ),
    );
  }

  Widget _getTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                AppRes.resultSearch,
                style: AppTextStyles.titleSmall,
              )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: FilterButton(
                  icon: AppIcons.sort,
                  tapCallback: widget.sortCallback,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.search,
              style: AppTextStyles.titleSmall
                  .copyWith(color: AppAllColors.lightAccent),
            ),
          )
        ],
      ),
    );
  }
}

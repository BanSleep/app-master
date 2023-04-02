import 'dart:io';

import 'package:collection/collection.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_theme_provider.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/request/filter_request.dart';
import 'package:cvetovik/models/api/response/filter_reponse.dart';
import 'package:cvetovik/models/api/shared/filter_data.dart';
import 'package:cvetovik/models/api/shared/prices.dart';
import 'package:cvetovik/pages/products/models/enum/filter_item_type.dart';
import 'package:cvetovik/pages/products/models/filter_result.dart';
import 'package:cvetovik/pages/products/widget/item/base/filter_parent_mix.dart';
import 'package:cvetovik/pages/products/widget/item/base/filter_result_mix.dart';
import 'package:cvetovik/pages/products/widget/item/filter_range_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/product/expander_widget.dart';
import '../item/filter_checkbox_list_widget.dart';
import '../item/filter_chips_widget.dart';
import '../item/filter_color_widget.dart';

class FilterDialog extends ConsumerWidget {
  final FilterResponse data;
  final List<GlobalKey> _keys = [];

  FilterDialog(this.data, this.filter);
  FilterData? filter;

  static bool allowSelected = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var items = _getFilters();
    print("ITEMS! ${items}");
    bool isDark = ref.watch(appThemeStateProvider);
    return AlertDialog(
      backgroundColor: (isDark) ? AppColors.darkBackground : AppColors.lightBg3,
      shape: (Platform.isIOS)
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)))
          : null,
      insetPadding: EdgeInsets.zero.copyWith(top: 55),
      //contentPadding: EdgeInsets.zero,
      //contentPadding: EdgeInsets.all(10.0),
      title: _getTitle(context),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width * 1,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items,
          ),
        ),
      ),
      actions: _getActions(context),
    );
  }

  List<Widget> _getActions(BuildContext context) {
    final double hPad = 18.w;
    return <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad),
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: 36.h, width: 270.w),
          child: ElevatedButton(
            onPressed: () {
              try {
                FilterDialog.allowSelected = true; // on Apply, allow selection
                FilterData currFilter = _getFilterAndPrices();
                Navigator.pop(context, currFilter);
              } catch (e) {
                print(e);
              }
            },
            child: Text(AppRes.apply,
                style:
                    AppTextStyles.titleSmall14.copyWith(color: Colors.white)),
            style: AppUi.buttonActionStyle,
          ),
        ),
      ),
      SizedBox(
        height: 10.h,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad),
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: 36.h, width: 270.w),
          child: ElevatedButton(
            style: AppUi.buttonActionStyle.copyWith(
                side: MaterialStateProperty.all(BorderSide(
                  width: 1.0,
                  color: AppColors.primary,
                )),
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () {
              _keys.forEach((key) {
                if (key.currentState is FilterParentMix) {
                  var state = key.currentState as FilterParentMix;
                  state.drop(); // problem here
                } else {
                  if (key.currentState is FilterResultMix) {
                    var state = key.currentState as FilterResultMix;
                    state.drop(); // and here
                  }
                }
              });
              //FilterData filter = _getFilterAndPrices();
              Navigator.pop(context, null);
            },
            child: Text(AppRes.drop,
                style: AppTextStyles.titleSmall14
                    .copyWith(color: AppColors.primary)),
          ),
        ),
      ),
      SizedBox(
        height: 10.h,
      ),
    ];
  }

  FilterData _getFilterAndPrices() {
    List<FilterResult> rawResult = [];
    _keys.forEach((key) {
      if (key.currentState is FilterResultMix) {
        var state = key.currentState as FilterResultMix;
        var result = state.getResult();
        if (result != null) rawResult.add(result);
      }
    });
    List<FilterOptions> filters = [];
    Prices? prices;
    rawResult.forEach((el) {
      if (el.filterType == FilterItemType.range) {
        prices = el.data as Prices;
      } else {
        var item = el.data as FilterOptions?;
        if (item != null) {
          filters.add(item);
        }
      }
    });
    var currFilter = FilterData(prices: prices, filters: filters);
    return currFilter;
  }

  Column _getTitle(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  close(context);
                },
              ),
            ),
            Text(
              AppRes.filters,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLargeSemiBold,
            ),
          ],
        ),
        Divider(
          endIndent: 0,
        ),
      ],
    );
  }

  void close(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  List<Widget> _getFilters() {
    List<Widget> items = [];

    void _addFilter(String title, FilterItemType type) {
      if (data.data!.filters == null) return;
      var currFilter = data.data!.filters!.values
          .firstWhereOrNull((element) => element.title == title);
      if (currFilter != null) {
        FilterOptions? selected;
        if (filter != null && filter!.filters != null) {
          selected = filter!.filters!.firstWhereOrNull(
              (element) => element.filter == currFilter.id.toString());
        }
        var key = GlobalKey();
        _keys.add(key);
        Widget? child;
        switch (type) {
          case FilterItemType.range:
            // TODO: Handle this case.
            break;
          case FilterItemType.color:
            child = FilterColorWidget(
              data: currFilter,
              key: key,
              selectedItems: _getSelectedItems(selected),
            );
            break;
          case FilterItemType.chip:
            child = FilterChipsWidget(
              data: currFilter,
              key: key,
              selectedItems: _getSelectedItems(selected),
            );
            break;
          case FilterItemType.checkbox:
            child = FilterCheckBoxListWidget(
                data: currFilter,
                key: key,
                selectedItems: _getSelectedItems(selected));
            break;
        }

        if (child != null) {
          items.add(ExpanderWidget(
            child: child,
            title: title,
          ));
        }
      }
    }

    if (data.data != null) {
      //add price
      var kPrice = GlobalKey();
      _keys.add(kPrice);
      var wPrice = FilterRangeWidget(
        prices: data.data!.prices,
        key: kPrice,
        selectedPrices: (filter != null) ? filter!.prices : null,
      );
      items.add(ExpanderWidget(
        child: wPrice,
        title: AppRes.price,
      ));

      _addFilter(AppRes.colorGamma, FilterItemType.color);
      _addFilter(AppRes.heightRose, FilterItemType.chip);
      _addFilter(AppRes.countRose, FilterItemType.chip);
      _addFilter(AppRes.kindRose, FilterItemType.checkbox);
      _addFilter(AppRes.country, FilterItemType.chip);
      _addFilter(AppRes.reason, FilterItemType.chip);
      // new filters
      _addFilter(AppRes.bouquetComposition, FilterItemType.chip);
      _addFilter(AppRes.flowerCount, FilterItemType.chip);
    }

    return items;
  }

  List<String>? _getSelectedItems(FilterOptions? selected) =>
      (selected != null) ? selected.options : null;
}

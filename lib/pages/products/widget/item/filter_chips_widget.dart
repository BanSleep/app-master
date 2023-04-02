import 'package:cvetovik/models/api/request/filter_request.dart';
import 'package:cvetovik/models/api/response/filter_reponse.dart';
import 'package:cvetovik/pages/products/models/enum/filter_item_type.dart';
import 'package:cvetovik/pages/products/models/filter_result.dart';
import 'package:cvetovik/pages/products/widget/content/filter/chip_item_widget.dart';
import 'package:cvetovik/pages/products/widget/filter/filter_dialog.dart';
import 'package:flutter/material.dart';

import 'base/filter_parent_mix.dart';
import 'base/filter_result_mix.dart';

// ignore: must_be_immutable
class FilterChipsWidget extends StatefulWidget {
  FilterChipsWidget({Key? key, required this.data, this.selectedItems})
      : super(key: key);
  final Filter data;
  List<String>? selectedItems;

  @override
  _FilterChipsWidgetState createState() => _FilterChipsWidgetState();
}

class _FilterChipsWidgetState extends State<FilterChipsWidget>
    with FilterResultMix, FilterParentMix {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: getChildren(widget.data.options),
    );
  }

  @override
  FilterResult? getResult() {
    FilterOptions? data = getFilterOptions(widget.data.id.toString());
    if (data != null)
      return FilterResult(filterType: FilterItemType.chip, data: data);
    else
      return null;
  }

  @override
  Widget getChildWidget(String key, String value, GlobalKey gKey) {
    if (!FilterDialog.allowSelected) {
      widget.selectedItems = null;
    }
    bool isSelected = checkSelected(key, widget.selectedItems);
    return ChipItemWidget(
      key: gKey,
      id: key,
      title: value,
      isSelected: isSelected,
    );
  }
}

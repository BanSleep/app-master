import 'package:cvetovik/models/api/request/filter_request.dart';
import 'package:cvetovik/models/api/response/filter_reponse.dart';
import 'package:cvetovik/pages/products/models/enum/filter_item_type.dart';
import 'package:cvetovik/pages/products/models/filter_result.dart';
import 'package:cvetovik/pages/products/widget/content/filter/filter_check_box_widget.dart';
import 'package:cvetovik/pages/products/widget/filter/filter_dialog.dart';
import 'package:cvetovik/pages/products/widget/item/base/filter_parent_mix.dart';
import 'package:flutter/material.dart';

import 'base/filter_result_mix.dart';

// ignore: must_be_immutable
class FilterCheckBoxListWidget extends StatefulWidget {
  FilterCheckBoxListWidget({Key? key, required this.data, this.selectedItems})
      : super(key: key);
  List<String>? selectedItems;
  final Filter data;

  @override
  _FilterCheckBoxListWidgetState createState() =>
      _FilterCheckBoxListWidgetState();
}

class _FilterCheckBoxListWidgetState extends State<FilterCheckBoxListWidget>
    with FilterResultMix, FilterParentMix {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: getChildren(widget.data.options),
    );
  }

  @override
  Widget getChildWidget(String key, String value, GlobalKey gKey) {
    if (!FilterDialog.allowSelected) {
      widget.selectedItems = null;
    }
    bool isSelected = checkSelected(key, widget.selectedItems);
    return FilterCheckBoxWidget(
      key: gKey,
      id: key,
      title: value,
      isSelected: isSelected,
    );
  }

  @override
  FilterResult? getResult() {
    FilterOptions? data = getFilterOptions(widget.data.id.toString());
    if (data != null)
      return FilterResult(filterType: FilterItemType.checkbox, data: data);
    else
      return null;
  }
}

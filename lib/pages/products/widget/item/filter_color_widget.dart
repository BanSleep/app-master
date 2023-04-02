import 'package:cvetovik/models/api/request/filter_request.dart';
import 'package:cvetovik/models/api/response/filter_reponse.dart';
import 'package:cvetovik/pages/products/models/enum/filter_item_type.dart';
import 'package:cvetovik/pages/products/models/filter_result.dart';
import 'package:cvetovik/pages/products/widget/content/filter/circle_color_widget.dart';
import 'package:cvetovik/pages/products/widget/filter/filter_dialog.dart';
import 'package:flutter/material.dart';

import 'base/filter_parent_mix.dart';
import 'base/filter_result_mix.dart';

// ignore: must_be_immutable
class FilterColorWidget extends StatefulWidget {
  final Filter data;
  List<String>? selectedItems;

  FilterColorWidget({Key? key, required this.data, this.selectedItems})
      : super(key: key);

  @override
  _FilterColorWidgetState createState() => _FilterColorWidgetState();
}

class _FilterColorWidgetState extends State<FilterColorWidget>
    with FilterResultMix, FilterParentMix {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: getChildren(widget.data.options),
          ),
        ),
        Divider()
      ],
    );
  }

  @override
  FilterResult? getResult() {
    FilterOptions? data = getFilterOptions(widget.data.id.toString());
    if (data != null) {
      return FilterResult(filterType: FilterItemType.color, data: data);
    } else
      return null;
  }

  @override
  Widget getChildWidget(String key, String value, GlobalKey gKey) {
    if (!FilterDialog.allowSelected) {
      widget.selectedItems = null;
    }
    bool isSelected = checkSelected(key, widget.selectedItems);
    return CircleColorWidget(
        key: gKey, id: key, color: value, isSelected: isSelected);
  }
}

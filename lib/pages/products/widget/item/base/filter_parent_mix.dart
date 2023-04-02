import 'package:collection/collection.dart';
import 'package:cvetovik/models/api/request/filter_request.dart';
import 'package:cvetovik/pages/products/widget/item/base/filter_child_mix.dart';
import 'package:flutter/material.dart';

mixin FilterParentMix {
  List<GlobalKey> keys = [];

  Widget getChildWidget(String key, String value, GlobalKey gKey);

  List<Widget> getChildren(Map<String, String> options) {
    List<Widget> children = [];
    options.forEach((key, value) {
      var k = GlobalKey();
      children.add(getChildWidget(key, value, k));
      keys.add(k);
    });
    children.add(Divider(
      endIndent: 0,
    ));
    return children;
  }

  void drop() {
    keys.forEach((key) {
      var state = key.currentState;
      if (state is FilterChildMix) {
        (state as FilterChildMix).drop();
      }
    });
  }

  FilterOptions? getFilterOptions(String id) {
    List<String> options = [];
    for (var key in keys) {
      if (key.currentState is FilterChildMix) {
        var state = key.currentState as FilterChildMix;
        if (state.selectedState()) {
          var id = state.getId();
          options.add(id);
        }
      }
    }
    if (options.length > 0) {
      var data = FilterOptions(filter: id, options: options);
      return data;
    } else
      return null;
  }

  bool checkSelected(String key, List<String>? selectedItems) {
    if (selectedItems != null && selectedItems.length > 0) {
      var curr = selectedItems.firstWhereOrNull((element) => element == key);
      if (curr != null) {
        return true;
      }
    }
    return false;
  }

  /*void onSelected(FilterSelected value) {
    keys.forEach((key) {
      if (key.currentState is FilterSelectedMix) {
        var state = key.currentState as FilterSelectedMix;
        state.updateSelected(value);
      }
    });
  }*/
}

import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/models/pages/obj_id.dart';
import 'package:cvetovik/pages/card/widgets/content/segment/segment_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnCategoryUpdated = void Function(String key);

class SegmentCategoryWidget extends StatefulWidget {
  const SegmentCategoryWidget(
      {Key? key, required this.items, required this.onUpdated})
      : super(key: key);
  final OnCategoryUpdated onUpdated;
  final List<ObjId> items;

  @override
  _SegmentCategoryWidgetState createState() => _SegmentCategoryWidgetState();
}

class _SegmentCategoryWidgetState extends State<SegmentCategoryWidget> {
  final List<GlobalKey<SegmentItemWidgetState>> _keys = [];

  List<Widget> children = [];
  late String _currentSelection;

  @override
  void initState() {
    _currentSelection = widget.items.first.id.toString();
    initChildren();
    super.initState();
  }

  void initChildren() {
    widget.items.forEach((el) {
      var key = GlobalKey<SegmentItemWidgetState>();
      children.add(SegmentItemWidget(
        key: key,
        item: el,
        isSelected: el.id == _currentSelection,
        onValueChanged: _onValueChanged,
      ));
      _keys.add(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.fillColor,
            borderRadius: BorderRadius.all(Radius.circular(10.r))),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }

  void _onValueChanged(String value) {
    _currentSelection = value.toString();
    _keys.forEach((element) {
      element.currentState!.updateSelected(_currentSelection);
    });
    widget.onUpdated(_currentSelection);
  }
}

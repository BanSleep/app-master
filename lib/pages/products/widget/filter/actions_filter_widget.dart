import 'package:collection/collection.dart';
import 'package:cvetovik/pages/products/models/enum/product_badges.dart';
import 'package:cvetovik/pages/products/widget/filter/action_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionsFilterWidget extends StatefulWidget {
  const ActionsFilterWidget(
      {Key? key, required this.items, required this.onActionUpdate})
      : super(key: key);
  final List<ProductBadges> items;
  final Function(List<ProductBadges> badges) onActionUpdate;
  @override
  _ActionsFilterWidgetState createState() => _ActionsFilterWidgetState();
}

class _ActionsFilterWidgetState extends State<ActionsFilterWidget> {
  int selectedIndex = -1;
  List<ProductBadges> badges = [];

  @override
  Widget build(BuildContext context) {
    if (widget.items.isNotEmpty) {
      return Column(
        children: [
          SizedBox(
            height: 24.h,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.items.length,
                itemBuilder: _itemBuilder,
                shrinkWrap: true,
              ),
            ),
          ),
          SizedBox(
            height: 18.h,
          ),
        ],
      );
    } else
      return SizedBox.shrink();
  }

  Widget _itemBuilder(BuildContext context, int index) {
    bool isSelected() => selectedIndex == index;

    var curr = widget.items[index];
    return ActionFilterItem(
      badge: curr,
      onTab: (badge, add) {
        /*setState(() {
          if (isSelected()) {
            selectedIndex = -1;
          } else {
            selectedIndex = index;
          }
          widget.onActionUpdate(selectedIndex != -1, curr);
        });*/
        var curr = badges.firstWhereOrNull((el) => el == badge);
        if (add) {
          if (curr == null) {
            badges.add(badge);
          }
        } else {
          if (curr != null) {
            badges.remove(curr);
          }
        }
        widget.onActionUpdate(badges);
      },
      selected: isSelected(),
    );
  }
}

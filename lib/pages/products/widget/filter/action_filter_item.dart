import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/products/models/enum/product_badges.dart';
import 'package:cvetovik/widgets/product/badges/mixin/badge_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionFilterItem extends StatefulWidget {
  const ActionFilterItem(
      {Key? key,
      required this.badge,
      required this.onTab,
      required this.selected})
      : super(key: key);

  final ProductBadges badge;
  final Function(ProductBadges badge, bool selected) onTab;
  final bool selected;

  @override
  State<ActionFilterItem> createState() => _ActionFilterItemState();
}

class _ActionFilterItemState extends State<ActionFilterItem> with BadgeMixin {
  bool selected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var title = getTitle(badge: widget.badge, isSmall: false);
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
        this.widget.onTab(this.widget.badge, selected);
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: _bgColor(),
          ),
          margin: EdgeInsets.only(
            right: 10.w,
          ),
          padding: EdgeInsets.only(left: 10.w, right: _rightPad()),
          child: Row(
            children: [
              Text(
                title,
                style: AppTextStyles.smallTitle13.copyWith(color: _textColor()),
              ),
              _closeButton(),
            ],
          )),
    );
  }

  Color _bgColor() {
    return (selected) ? AppAllColors.black : AppAllColors.lightGrey;
  }

  Color _textColor() {
    return (selected) ? Colors.white : Colors.black;
  }

  Widget _closeButton() {
    if (selected) {
      return Padding(
        padding: EdgeInsets.only(left: 10.w, right: 7.w),
        child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
                child: Icon(
              Icons.clear,
              size: 7.h,
            ))),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  double _rightPad() {
    return (selected) ? 0 : 10.w;
  }
}

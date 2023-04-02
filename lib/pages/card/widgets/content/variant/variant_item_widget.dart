import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnSelected = void Function(bool selected, String title);

class VariantItemWidget extends StatefulWidget {
  const VariantItemWidget(
      {Key? key,
      required this.title,
      required this.onSelected,
      this.isSelected = false})
      : super(key: key);
  final OnSelected onSelected;
  final String title;
  final isSelected;

  @override
  VariantItemWidgetState createState() => VariantItemWidgetState();
}

class VariantItemWidgetState extends State<VariantItemWidget> {
  late bool _isSelected;

  String get title => widget.title;

  void removeSelected() {
    if (_isSelected) {
      setState(() {
        _isSelected = false;
      });
    }
  }

  @override
  void initState() {
    _isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!_isSelected) {
          setState(() {
            _isSelected = !_isSelected;
            widget.onSelected(_isSelected, widget.title);
          });
        }
      },
      child: Container(
        width: 80.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: _getBorderColor()),
          color: _getColor(),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 8.h,
        ),
        child: Center(
          child: Text(
            widget.title,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleSmall14,
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    return (_isSelected) ? Colors.white : AppAllColors.lightGrey;
  }

  Color _getBorderColor() {
    return (_isSelected) ? AppAllColors.lightAccent : AppAllColors.lightGrey;
  }
}

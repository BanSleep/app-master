import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnChanged = void Function(bool value);

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget(
      {Key? key,
      required this.title,
      this.onChanged,
      this.smallSize = false,
      this.selected = false})
      : super(key: key);
  final String title;
  final OnChanged? onChanged;
  final bool smallSize;
  final bool selected;
  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> with SetBoolMixin {
  late bool _selected;

  @override
  void initState() {
    _selected = widget.selected;
    super.initState();
  }

  @override
  bool value() => _selected;

  @override
  Widget build(BuildContext context) {
    final double size = (widget.smallSize) ? 20.h : 25.h;
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          _selected = !_selected;
          if (widget.onChanged != null) widget.onChanged!(_selected);
        });
      },
      child: _checkLeft(size),
    );
  }

  Widget _checkLeft(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _getBaseContainer(size),
        Padding(
          padding: EdgeInsets.only(left: 10.h),
          child: _getTitle(),
        )
      ],
    );
  }

  Container _getBaseContainer(double size) => _baseContainer(size);

  Text _getTitle() => Text(widget.title, style: AppTextStyles.textField);

  Container _baseContainer(double size) {
    return Container(
      width: size,
      height: size,
      child: Visibility(
        visible: _selected,
        child: Center(
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(
          color: _getColor(),
          width: 1,
        ),
        color: _getColor(),
      ),
    );
  }

  Color _getColor() =>
      (_selected) ? AppAllColors.lightAccent : AppAllColors.lightGrey;
}

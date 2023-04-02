import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/products/widget/item/base/filter_child_mix.dart';
import 'package:flutter/material.dart';

class FilterCheckBoxWidget extends StatefulWidget {
  const FilterCheckBoxWidget(
      {Key? key, required this.id, required this.title, this.isSelected})
      : super(key: key);

  final String id;
  final String title;
  final bool? isSelected;

  @override
  _FilterCheckBoxWidgetState createState() => _FilterCheckBoxWidgetState();
}

class _FilterCheckBoxWidgetState extends State<FilterCheckBoxWidget>
    with FilterChildMix {
  @override
  void initState() {
    if (widget.isSelected != null && (widget.isSelected!)) {
      isSelected = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
            value: isSelected,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            activeColor: AppColors.primary,
            onChanged: (bool? value) {
              setState(() {
                isSelected = value!;
              });
            }),
        InkWell(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          child: Text(widget.title, style: AppTextStyles.textField),
        )
      ],
    );
  }

  @override
  String getId() => widget.id;

  @override
  void drop() {
    dropBase(() {
      setState(() {});
    });
  }
}

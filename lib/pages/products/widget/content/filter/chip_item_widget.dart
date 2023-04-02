import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/products/widget/item/base/filter_child_mix.dart';
import 'package:flutter/material.dart';

class ChipItemWidget extends StatefulWidget {
  final String id;
  final String title;
  final bool? isSelected;
  const ChipItemWidget({
    Key? key,
    required this.id,
    required this.title,
    this.isSelected,
  }) : super(key: key);

  @override
  _ChipItemWidgetState createState() => _ChipItemWidgetState();
}

class _ChipItemWidgetState extends State<ChipItemWidget> with FilterChildMix {
  //isSelected = false;

  @override
  void initState() {
    if (widget.isSelected != null && (widget.isSelected!)) {
      isSelected = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Chip(
        labelPadding: EdgeInsets.all(4.0),
        label: Text(
          widget.title,
          style: AppTextStyles.textField.copyWith(color: _getColor()),
        ),
        backgroundColor: (isSelected) ? AppColors.primary : Colors.white,
        elevation: 0.0,
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  @override
  String getId() => widget.id;

  /*void updateSelected(FilterSelected value) {
    if(value.id != widget.id){
      if(isSelected && value.selected){
        setState(() {
          isSelected =false;
        });
      }
    }
  }*/

  Color _getColor() => (isSelected) ? Colors.white : Colors.black;

  @override
  void drop() {
    dropBase(() {
      setState(() {});
    });
  }

  /*@override
  void drop() {
    if(isSelected){
      setState(() {
        isSelected = false;
      });
    }
  }*/
}

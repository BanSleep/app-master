import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/models/pages/obj_id.dart';
import 'package:flutter/material.dart';

typedef OnValueChanged = void Function(String id);

class SegmentItemWidget extends StatefulWidget {
  const SegmentItemWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.onValueChanged,
  }) : super(key: key);
  final ObjId item;
  final OnValueChanged onValueChanged;
  final bool isSelected;
  @override
  SegmentItemWidgetState createState() => SegmentItemWidgetState();
}

class SegmentItemWidgetState extends State<SegmentItemWidget> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onValueChanged(widget.item.id);
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          decoration: BoxDecoration(
              color: AppColors.fillColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            decoration: BoxDecoration(
                color: (isSelected) ? Colors.white : AppColors.fillColor,
                borderRadius: BorderRadius.all(Radius.circular(7))),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            //TODO 1change to self widget
            child: Text(widget.item.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.primary : AppColors.grey)),
          )),
    );
  }

  void updateSelected(String index) {
    setState(() {
      isSelected = index == widget.item.id;
    });
    print(index);
  }
}

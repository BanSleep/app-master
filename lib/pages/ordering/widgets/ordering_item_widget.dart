import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderingItemWidget extends StatefulWidget {
  const OrderingItemWidget({Key? key, required this.title, required this.id})
      : super(key: key);
  final String title;
  final int id;
  @override
  OrderingItemWidgetState createState() => OrderingItemWidgetState();
}

class OrderingItemWidgetState extends State<OrderingItemWidget> {
  late bool selected;

  int get id => widget.id;

  void onSelected(bool value) {
    if (value != selected) {
      setState(() {
        selected = value;
      });
    }
  }

  @override
  void initState() {
    selected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 138.w,
      child: Center(
          child: Text(
        widget.title,
        style: AppTextStyles.textLessMediumBold.copyWith(color: _getColor()),
      )),
    );
  }

  Color _getColor() {
    print(widget.id);
    var res =
        (selected) ? AppAllColors.lightAccent : AppAllColors.lightDarkGrey;
    print(res);
    return res;
  }
}

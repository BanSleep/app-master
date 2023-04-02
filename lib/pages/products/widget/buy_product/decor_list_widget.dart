import 'package:collection/collection.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/linked/linked_decors_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'decor_item_widget.dart';

class DecorListWidget extends StatefulWidget {
  const DecorListWidget({Key? key, required this.decor, this.selected})
      : super(key: key);
  final LinkedDecor decor;
  final List<CartAddData>? selected;
  @override
  _DecorListWidgetState createState() => _DecorListWidgetState();
}

class _DecorListWidgetState extends State<DecorListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 17.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 9.h),
            child: Text(widget.decor.title,
                textAlign: TextAlign.start,
                style: AppTextStyles.titleVerySmall),
          ),
          SizedBox(
            height: 48.h,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: widget.decor.products.values
                  .map((e) => DecorItemWidget(
                        item: e,
                        isSelected: _checkSelected(e),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  bool _checkSelected(DecorProduct e) {
    if (widget.selected != null) {
      var curr =
          widget.selected!.firstWhereOrNull((el) => el.productId == e.id);
      return (curr != null);
    }
    return false;
  }
}

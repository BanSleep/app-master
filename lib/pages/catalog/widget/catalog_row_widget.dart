import 'package:cvetovik/models/api/response/catalog_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'catalog_first_item_widget.dart';

class CatalogRowWidget extends StatelessWidget {
  const CatalogRowWidget({Key? key, required this.items}) : super(key: key);
  final List<CatalogData> items;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.67.h),
      child: IntrinsicHeight(
        child: Row(
          //mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items
              .map((e) => CatalogFirstItemWidget(
                    item: e,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

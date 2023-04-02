import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountActionWidget extends StatelessWidget {
  const CountActionWidget(
      {Key? key, required this.tapAction, required this.iconData})
      : super(key: key);
  final AsyncCallback tapAction;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await tapAction();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppAllColors.iconsWhite2, width: 1)),
        child: Icon(
          iconData,
          size: 24.h,
        ),
      ),
    );
  }
}

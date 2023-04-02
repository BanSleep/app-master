import 'package:cached_network_image/cached_network_image.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubcategoryImageItemWidget extends StatelessWidget {
  const SubcategoryImageItemWidget({Key? key, required this.source})
      : super(key: key);
  final String? source;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: AppAllColors.commonColorsWhite,
        radius: 15.r,
        child: _getImage());
  }

  Widget _getImage() {
    if (source != null) {
      return ClipOval(
        child: CachedNetworkImage(
          width: 30.h,
          height: 30.h,
          imageUrl: source!,
          fit: BoxFit.fitWidth,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

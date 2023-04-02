import 'package:align_positioned/align_positioned.dart';
import 'package:cvetovik/widgets/share/circle_point.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterButton extends StatelessWidget {
  const FilterButton(
      {Key? key,
      required this.icon,
      required this.tapCallback,
      this.isSelected = false})
      : super(key: key);
  final String icon;
  final AsyncCallback? tapCallback;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    final double size = 34.h;
    return InkWell(
      onTap: () async {
        if (tapCallback != null) {
          await tapCallback!();
        }
      },
      child: Container(
        height: size,
        width: size,
        child: Stack(
          children: [
            SvgPicture.asset(
              icon,
              height: size,
              width: size,
            ),
            AlignPositioned(
              child: isSelected
                  ? CirclePoint(
                      size: 8.r,
                    )
                  : Container(),
              alignment: Alignment(1, -1),
              touch: Touch.middle,
            )
          ],
        ),
      ),
    );
  }
}

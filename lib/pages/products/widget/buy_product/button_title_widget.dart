import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonTitleWidget extends StatelessWidget {
  const ButtonTitleWidget(
      {Key? key,
      required this.width,
      required this.height,
      required this.icon,
      required this.title,
      required this.style})
      : super(key: key);
  final double width;
  final double height;
  final String icon;
  final String title;
  final TextStyle style;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          icon,
          color: Colors.white,
          width: width,
          height: height,
        ),
        Padding(
          padding: EdgeInsets.only(left: 6.0.w),
          child: Text(
            title,
            style: style,
          ),
        )
      ],
    );
  }
}

import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CounterButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  const CounterButton({Key? key, required this.onTap, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        height: 36.h,
        width: 43.w,
        decoration: BoxDecoration(
          color: AppColors.lightBg3,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        //width: 36,

        child: IconButton(
            highlightColor: Colors.transparent,
            color: AppAllColors.lightGrey2,
            iconSize: 22.h,
            onPressed: () {
              onTap();
            },
            icon: Icon(icon)),
      ),
    );
  }
}

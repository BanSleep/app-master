import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeIntervalWidget extends StatelessWidget {
  const TimeIntervalWidget(
      {Key? key,
      required this.interval,
      required this.items,
      required this.onSelected})
      : super(key: key);
  final String interval;
  final List<String> items;
  final Function(String value) onSelected;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: AppAllColors.lightGrey,
            width: 1,
          ),
          color: AppAllColors.lightGrey,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 12),
          child: DropdownButton<String>(
            value: interval,
            //elevation: 16,
            icon: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: SvgPicture.asset(
                    AppIcons.time,
                    height: 18.h,
                    width: 18.w,
                  ),
                ),
              ],
            ),
            isDense: false,
            isExpanded: true,
            style: AppTextStyles.textDateTime,
            underline: Container(
              height: 0,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              print("on selected!");
              if (newValue != null) onSelected(newValue);
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: AppTextStyles.textDateTime,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

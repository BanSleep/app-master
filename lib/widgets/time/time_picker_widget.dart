import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({Key? key}) : super(key: key);

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> with GetStrMixin {
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  String value() {
    return _selectedTime.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picker = await showTimePicker(
            context: context,
            helpText: AppRes.selectTime,
            cancelText: AppRes.cancel.toUpperCase(),
            confirmText: AppRes.ok.toUpperCase(),
            initialTime: _selectedTime,
            builder: (context, childWidget) {
              return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: childWidget!);
            });
        if (picker != null) {
          _selectedTime = picker;
        }
      },
      child: Container(
        width: 147.w,
        height: 38.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: AppAllColors.lightGrey,
            width: 1,
          ),
          color: AppAllColors.lightGrey,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox.shrink(),
            Text(
              _selectedTime.format(context).replaceAll('PM', '').replaceAll('AM', ''),
              style: AppTextStyles.textDateTime,
            ),
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
      ),
    );
  }
}

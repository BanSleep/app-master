import 'dart:developer';

import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime)? onUpdate;

  final List<TimeRangeData>? timeRanges;
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? birthDate;
  final bool isTimePicker;
  final bool isRowPickers;

  const DatePickerWidget({
    Key? key,
    this.onUpdate,
    this.minDate,
    this.maxDate,
    this.birthDate,
    this.timeRanges,
    this.isTimePicker = false,
    this.isRowPickers = false,
  }) : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget>
    with GetStrMixin, TimeRangeUpdateMixin {
  DateTime _selectedDate = DateTime.now();
  DateTime _minDate = DateTime.now();
  final DateFormat formattedDate = DateFormat(AppUi.dateFormatStr);
  bool firstTime = true;
  bool minDateChosen = false;
  bool isOtherBirthdayChosen = false;

  void initTimeRanges() {
    DateTime oldSelectedDate = _selectedDate;
    if (widget.timeRanges != null) {
      // todo: refactor
      print("time ranges len: ${widget.timeRanges!.length}");
      var currHour = DateTime.now().hour;
      var currDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      var dt =
          DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      List<TimeRangeData>? currRangers;
      if (dt == currDate)
        currRangers = widget.timeRanges!
            .where((e) => e.startHour > currHour && e.startHour >= e.closeHour)
            .toList();
      else
        currRangers = widget.timeRanges;
      if (currRangers!.length == 0 && !firstTime) {
        // log("cur ranges len 0");
        _minDate = DateTime.now();
        _minDate = DateTime(_minDate.year, _minDate.month, _minDate.day + 1);
        if ((_selectedDate.day < _minDate.day &&
                _selectedDate.month == _minDate.month) ||
            _selectedDate.month < _minDate.month) {
          _selectedDate = DateTime(_minDate.year, _minDate.month, _minDate.day);
        }
        // firstTime = false;
      } else {
        // _minDate = DateTime.now();
      }
      if (widget.birthDate != null) {
        _selectedDate = widget.birthDate!;
      }
      // print("available ranges len: ${currRangers.length}");
    }
    DateTime newSelectedDate = _selectedDate;
    log("init time ranges fired! $_selectedDate, $_minDate");
    setState(() {
      // print("set state");
      // log("$newSelectedDate $oldSelectedDate ${newSelectedDate != oldSelectedDate}");
      if (widget.onUpdate != null && newSelectedDate != oldSelectedDate ||
          firstTime) {
        widget.onUpdate!(_selectedDate);
        firstTime = false;
      }
    });
  }

  @override
  void initState() {
    // initTimeRanges();
    super.initState();
    if (widget.minDate != null) {
      _minDate = widget.minDate!;
      minDateChosen = true;
    }
  }

  @override
  String value() {
    return formattedDate.format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    // initTimeRanges();
    if (widget.birthDate != null && !isOtherBirthdayChosen) {
      _selectedDate = widget.birthDate!;
      isOtherBirthdayChosen = true;
    }
    log("build date picker $_selectedDate $_minDate");
    return InkWell(
      onTap: () async {
        if (widget.isTimePicker) {
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
              hour: DateTime.now().hour,
              minute: DateTime.now().minute,
            ),
            builder: (context, child) {
              return pickerTheme(child);
            },
          );

          if (picked != null &&
              picked.hour != _selectedDate.hour &&
              picked.minute != _selectedDate.minute) {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
                  _selectedDate.day, picked.hour, picked.minute);
              if (widget.onUpdate != null) {
                widget.onUpdate!(_selectedDate);
              }
            });
          }
        } else {
          final DateTime? picked = await showDatePicker(
            context: context,
            builder: (context, child) {
              return pickerTheme(child);
            },
            initialDate: widget.birthDate == null
                ? (!minDateChosen ? _minDate : DateTime.now())
                : widget.birthDate!,
            firstDate: _minDate,
            // здесь можно
            lastDate: widget.maxDate == null
                ? DateTime(DateTime.now().year + 2)
                : widget.maxDate!,
            //locale: Locale('en'),
          );

          if (picked != null && picked != _selectedDate) {
            setState(() {
              _selectedDate = picked;
              if (widget.onUpdate != null) {
                widget.onUpdate!(_selectedDate);
              }
            });
          }
        }
      },
      child: Container(
        width: widget.isRowPickers ? 123.w : 147.w,
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
              widget.isTimePicker
                  ? DateFormat('hh:mm').format(_selectedDate)
                  : formattedDate.format(_selectedDate),
              style: AppTextStyles.textDateTime,
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: SvgPicture.asset(
                widget.isTimePicker ? AppIcons.time : AppIcons.date,
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

Theme pickerTheme(Widget? child) {
  return Theme(
    data: ThemeData.light().copyWith(
        primaryColor: AppAllColors.lightAccent,
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        colorScheme: ColorScheme.light(primary: AppAllColors.lightAccent)
            .copyWith(secondary: AppAllColors.lightAccent)),
    child: child!,
  );
}

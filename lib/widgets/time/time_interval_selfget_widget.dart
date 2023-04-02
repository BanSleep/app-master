import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:cvetovik/widgets/time/time_interval_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'mixin/time_interval_mix.dart';

class TimeIntervalSelfGetWidget extends StatefulWidget {
  const TimeIntervalSelfGetWidget({
    Key? key,
    required this.timeRanges,
  }) : super(key: key);
  final List<ShopTimeRange> timeRanges;

  @override
  _TimeIntervalSelfGetWidgetState createState() =>
      _TimeIntervalSelfGetWidgetState();
}

class _TimeIntervalSelfGetWidgetState extends State<TimeIntervalSelfGetWidget>
    with TimeIntervalMixin, SetTimeRangeSelfGetMixin, GetStrMixin {
  late String interval;
  late List<String> items;
  late List<ShopTimeRange> timeRanges;
  late List<ShopTimeRange> currRangers;
  DateTime selectedDt = DateTime.now();

  @override
  void initState() {
    super.initState();
    setState(() {
      timeRanges = widget.timeRanges;
      _initIntervals();
    });
  }

  void _initIntervals() {
    var currHour = DateTime.now().hour;
    var currDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var dt = DateTime(selectedDt.year, selectedDt.month, selectedDt.day);
    if (dt == currDate) {
      currRangers = timeRanges
          .where((element) =>
              element.startHour > currHour &&
              element.startHour >= element.closeHour)
          .toList();
    } else {
      currRangers = timeRanges;
    }
    items = currRangers.map((e) => getInterval(e)).toList();
    if (items.length > 0)
      interval = items.first;
    else
      interval = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 147.w,
        child: TimeIntervalWidget(
          items: items,
          interval: interval,
          onSelected: _onSelected,
        ));
  }

  _onSelected(String value) {
    setState(() {
      interval = value;
      //_selected = items.indexOf(interval);
    });
  }

  @override
  void initTimeRangeValueWithDt(DateTime value) {
    setState(() {
      selectedDt = value;
      _initIntervals();
    });
  }

  @override
  String value() {
    //var curr = currRangers[_selected];
    return interval.replaceAll(':00', '');
  }
}

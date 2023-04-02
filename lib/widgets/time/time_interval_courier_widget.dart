import 'dart:developer';

import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/pages/ordering/models/enums/zones_delivery.dart';
import 'package:cvetovik/pages/ordering/providers/ordering/ordering_bloc.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:cvetovik/widgets/time/mixin/time_interval_mix.dart';
import 'package:cvetovik/widgets/time/time_interval_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class TimeIntervalCourierWidget extends StatefulWidget {
  final List<TimeRangeData> timeRanges;
  final Function(TimeRangeData pos)? onUpdatedRange;
  final WidgetRef blocRef;
  final ZonesDelivery zone;

  const TimeIntervalCourierWidget({
    Key? key,
    required this.timeRanges,
    this.onUpdatedRange,
    required this.blocRef,
    required this.zone,
  }) : super(key: key);

  @override
  _TimeIntervalCourierWidgetState createState() =>
      _TimeIntervalCourierWidgetState();
}

class _TimeIntervalCourierWidgetState extends State<TimeIntervalCourierWidget>
    with
        TimeIntervalValueCourierMixin,
        InitTimeRangeCourierMixin,
        SetTimeRangeSelfGetMixin,
        TimeIntervalMixin {
  late String interval;
  late List<String> items;
  late List<TimeRangeData> timeRanges;
  late List<TimeRangeData> currRangers;
  int _selected = 0;
  DateTime selectedDt = DateTime.now();

  @override
  void initState() {
    super.initState();
    setState(() {
      timeRanges = widget.timeRanges;
      _initIntervals();
    });
  }

  @override
  void didUpdateWidget(TimeIntervalCourierWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.zone != widget.zone) {
      setState(() {
        timeRanges = widget.timeRanges;
        _initIntervals();
      });
    }
  }

  // final orderingBlocProvider = Provider<OrderingBloc>((ref) {
  //   return OrderingBloc(ref);
  // });

  List<String> _getItemsForDate() {
    var currHour = DateTime.now().hour;
    var currDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var dt = DateTime(selectedDt.year, selectedDt.month, selectedDt.day);

    var bloc = widget.blocRef.read(orderingBlocProvider);
    var res = bloc.getTimeRanges(dt, widget.zone.index);
    // print("res for $dt getTimeRanges "
    //     "from block inside"
    //     " time_interval_courier_widget: ${res.map((e) => e.toJson())}");
    // print("len : ${res.length}");

    // timeRanges = res;
    timeRanges = [];
    log("zone defined: ${widget.zone.index}");
    for (int i = 0; i < res.length; i++) {
      TimeRangeData cur = res[i];
      print("comparing zones cur(${cur.zone}) & widget(${widget.zone.index})");
      if (cur.zone == widget.zone.index) {
        timeRanges.add(cur);
      }
    }

    if (dt == currDate) {
      currRangers = timeRanges
          .where((element) =>
              element.startHour > currHour &&
              element.startHour >= element.closeHour)
          .toList();
    } else {
      currRangers = timeRanges;
    }

    print("len cr : ${currRangers.length}");

    return currRangers.map((e) => getInterval(e)).toList();
  }

  void _initIntervals() {
    items = _getItemsForDate();
    print("| time intervals available | date ${selectedDt} | : ${items}");
    if (items.length > 0)
      interval = items.first;
    else
      interval = '';
  }

  @override
  Widget build(BuildContext context) {
    return TimeIntervalWidget(
      items: items,
      interval: interval,
      onSelected: _onSelected,
    );
  }

  @override
  void initTimeRangeValue(List<TimeRangeData> value) {
    setState(() {
      timeRanges = value;
      _initIntervals();
    });
  }

  @override
  Tuple2<TimeRangeData, String>? value() {
    if (currRangers.isNotEmpty) {
      var curr = currRangers[_selected];
      return Tuple2<TimeRangeData, String>(curr, interval);
    }
    return null;
  }

  _onSelected(String value) {
    setState(() {
      interval = value;
      _selected = items.indexOf(interval);
    });
    if (widget.onUpdatedRange != null) {
      var curr = currRangers[_selected];
      widget.onUpdatedRange!(curr);
    }
  }

  @override
  void initTimeRangeValueWithDt(DateTime value) {
    setState(() {
      selectedDt = value;
      _initIntervals();
    });
  }
}

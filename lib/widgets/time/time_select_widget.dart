import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/pages/ordering/models/enums/zones_delivery.dart';
import 'package:cvetovik/widgets/check_box_widget.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:cvetovik/widgets/time/models/time_data.dart';
import 'package:cvetovik/widgets/time/time_interval_courier_widget.dart';
import 'package:cvetovik/widgets/time/time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class TimeSelectWidget extends StatefulWidget {
  final List<TimeRangeData> timeRanges;
  final Function(TimeRangeData pos)? onUpdatedRange;
  final Function(ZonesDelivery pos)? onUpdatedZone;
  final Function(bool value)? onUpdatedExactTime;
  final WidgetRef blocRef;
  final ZonesDelivery zone;

  const TimeSelectWidget({
    Key? key,
    required this.timeRanges,
    this.onUpdatedRange,
    this.onUpdatedExactTime,
    this.onUpdatedZone,
    required this.blocRef,
    required this.zone,
  }) : super(key: key);

  @override
  State<TimeSelectWidget> createState() => _TimeSelectWidgetState();
}

class _TimeSelectWidgetState extends State<TimeSelectWidget>
    with GetTimeMixin, SetTimeRangeZoneMixin, SetTimeRangeSelfGetMixin {
  bool extractTime = false;
  bool showExtractTime = true;
  var keyTime = GlobalKey();
  var keyInterval = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 147.w,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: showExtractTime,
              child: CheckBoxWidget(
                title: AppRes.extractTime,
                smallSize: true,
                onChanged: _onChangedExtractTime,
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            //TimePickerWidget(key: keyTime),
            (extractTime)
                ? TimePickerWidget(
                    key: keyTime,
                  )
                : TimeIntervalCourierWidget(
                    timeRanges: widget.timeRanges,
                    key: keyInterval,
                    onUpdatedRange: widget.onUpdatedRange,
                    blocRef: widget.blocRef,
                    zone: widget.zone,
                  ),
          ]),
    );
  }

  void _onChangedExtractTime(bool value) {
    setState(() {
      extractTime = value;
    });
    widget.onUpdatedExactTime!(value);
  }

  @override
  TimeData value() {
    String value = '';
    TimeRangeData? timeRange;
    if (extractTime) {
      value = (keyTime.currentState! as GetStrMixin).value();
    } else {
      var res =
          (keyInterval.currentState! as TimeIntervalValueCourierMixin).value();
      if (res != null) {
        value = res.item2;
        timeRange = res.item1;
      }
    }
    return TimeData(extractTime, value, timeRange);
  }

  @override
  void initTimeRangeValue(Tuple2<List<TimeRangeData>, ZonesDelivery> value) {
    (keyInterval.currentState as InitTimeRangeCourierMixin)
        .initTimeRangeValue(value.item1);

    widget.onUpdatedZone?.call(value.item2);
    if (value.item2 != ZonesDelivery.zone1) {
      setState(() {
        extractTime = false;
        showExtractTime = false;
      });
    } else {
      if (showExtractTime == false) {
        setState(() {
          showExtractTime = true;
        });
      }
    }
  }

  @override
  void initTimeRangeValueWithDt(DateTime dt) {
    if (keyInterval.currentState is SetTimeRangeSelfGetMixin) {
      (keyInterval.currentState as SetTimeRangeSelfGetMixin)
          .initTimeRangeValueWithDt(dt);
    }
  }
}

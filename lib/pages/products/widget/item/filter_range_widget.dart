import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/shared/prices.dart';
import 'package:cvetovik/pages/products/models/enum/filter_item_type.dart';
import 'package:cvetovik/pages/products/models/filter_result.dart';
import 'package:cvetovik/pages/products/widget/filter/filter_dialog.dart';
import 'package:cvetovik/pages/products/widget/item/base/filter_result_mix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

// ignore: must_be_immutable
class FilterRangeWidget extends StatefulWidget {
  final Prices prices;
  Prices? selectedPrices;

  FilterRangeWidget({
    Key? key,
    required this.prices,
    this.selectedPrices,
  }) : super(key: key);

  @override
  _FilterRangeWidgetState createState() => _FilterRangeWidgetState();
}

class _FilterRangeWidgetState extends State<FilterRangeWidget>
    with FilterResultMix {
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    initRange();
    super.initState();
  }

  void initRange() {
    // print("called init range of $selectedCurr");
    if (FilterDialog.allowSelected && widget.selectedPrices != null) {
      // w/ filter
      _currentRangeValues = RangeValues(widget.selectedPrices!.min.toDouble(),
          widget.selectedPrices!.max.toDouble());
    } else {
      // w/o filter
      _currentRangeValues = RangeValues(
          widget.prices.min.toDouble(), widget.prices.max.toDouble());
    }
  }

  @override
  void drop() {
    setState(() {
      FilterDialog.allowSelected = false;
      initRange();
    });
  }

  @override
  Widget build(BuildContext context) {
    double firstRange = widget.prices.max.toDouble() * 0.3;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: FlutterSlider(
              step: FlutterSliderStep(
                  step: 10, // default
                  isPercentRange: true,
                  rangeList: [
                    FlutterSliderRangeStep(from: 0, to: firstRange, step: 1),
                  ]),
              values: [_currentRangeValues.start, _currentRangeValues.end],
              trackBar: FlutterSliderTrackBar(
                activeTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.primary),
                activeTrackBarHeight: 5,
              ),
              visibleTouchArea: false,
              rangeSlider: true,
              min: widget.prices.min.toDouble(),
              max: widget.prices.max.toDouble(),
              handler: _getHandler(),
              rightHandler: _getHandler(),
              onDragging: (handlerIndex, lowerValue, upperValue) {
                setState(() {
                  _currentRangeValues = RangeValues(lowerValue, upperValue);
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                '${AppRes.from} ${_currentRangeValues.start}${AppRes.shortCurrency}',
                style: AppTextStyles.textField),
            Text(
                '${AppRes.to} ${_currentRangeValues.end}${AppRes.shortCurrency}',
                style: AppTextStyles.textField)
          ],
        ),
        Divider()
      ],
    );
  }

  FlutterSliderHandler _getHandler() {
    return FlutterSliderHandler(
      decoration: BoxDecoration(),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        width: 20,
        height: 20,
      ),
    );
  }

  @override
  FilterResult getResult() {
    return FilterResult(
        filterType: FilterItemType.range,
        data: Prices(
            min: _currentRangeValues.start.toInt(),
            max: _currentRangeValues.end.toInt()));
  }
}

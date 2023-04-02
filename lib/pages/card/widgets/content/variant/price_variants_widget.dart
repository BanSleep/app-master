import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:cvetovik/pages/card/widgets/content/variant/variant_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnSelectVersion = void Function(String title);

class PriceVariantsWidget extends StatefulWidget {
  const PriceVariantsWidget(
      {Key? key,
      required this.versions,
      required this.onSelect,
      required this.title,
      this.selectedTitle = ''})
      : super(key: key);
  final OnSelectVersion onSelect;
  final List<Version> versions;
  final String title;
  final String selectedTitle;
  @override
  _PriceVariantsWidgetState createState() => _PriceVariantsWidgetState();
}

class _PriceVariantsWidgetState extends State<PriceVariantsWidget> {
  List<GlobalKey> keys = [];
  late String selectedTitle;

  @override
  void initState() {
    selectedTitle = widget.selectedTitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: Text(widget.title,
              textAlign: TextAlign.start, style: AppTextStyles.titleVerySmall),
        ),
        Wrap(
          spacing: 13.0.w,
          runSpacing: 6.0,
          children: widget.versions.map((e) => _getVariantItem(e)).toList(),
        ),
      ],
    );
  }

  VariantItemWidget _getVariantItem(Version e) {
    var key = GlobalKey();
    keys.add(key);
    bool isSelected = false;
    if (selectedTitle.isEmpty) {
      isSelected = widget.versions.first.title == e.title;
    } else {
      isSelected = e.title == selectedTitle;
    }
    print('selected $isSelected');
    return VariantItemWidget(
      key: key,
      title: e.title,
      onSelected: _onSelected,
      isSelected: isSelected,
    );
  }

  void _onSelected(bool selected, String title) {
    title = title;
    keys.forEach((element) {
      if (element.currentState != null) {
        var curr = element.currentState as VariantItemWidgetState;
        if (curr.title != title) {
          curr.removeSelected();
        } else {
          var variant = widget.versions
              .firstWhere((element) => element.title == curr.title);
          widget.onSelect(variant.title);
        }
      } else {
        print('not find state');
      }
    });
  }
}

import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/products/models/enum/sort/sort_type.dart';
import 'package:flutter/cupertino.dart';

typedef OnSort = Future<void> Function(SortType sort);

class SortListWidget extends StatefulWidget {
  const SortListWidget({Key? key, required this.sortType, required this.onSort})
      : super(key: key);
  final SortType sortType;
  final OnSort onSort;
  @override
  _SortListWidgetState createState() => _SortListWidgetState();
}

class _SortListWidgetState extends State<SortListWidget> {
  late SortType currSort;

  @override
  void initState() {
    currSort = widget.sortType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          AppRes.sortCatalog,
          style: AppTextStyles.textActionSelected,
        ),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(
            AppRes.sortUpPrice,
            style: _getStyle(currSort == SortType.upPrice),
          ),
          onPressed: () async {
            setState(() {
              currSort = SortType.upPrice;
            });
            Navigator.pop(context);
            await widget.onSort(currSort);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(AppRes.sortDownPrice,
              style: _getStyle(currSort == SortType.downPrice)),
          onPressed: () async {
            setState(() {
              currSort = SortType.downPrice;
            });
            Navigator.pop(context);
            await widget.onSort(currSort);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(AppRes.sortUpPop,
              style: _getStyle(currSort == SortType.upPop)),
          onPressed: () async {
            setState(() {
              currSort = SortType.upPop;
            });
            Navigator.pop(context);
            await widget.onSort(currSort);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(AppRes.sortDownPop,
              style: _getStyle(currSort == SortType.downPop)),
          onPressed: () async {
            setState(() {
              currSort = SortType.downPop;
            });
            await widget.onSort(currSort);
            Navigator.pop(context);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        child: Text(
          AppRes.cancel,
          style: AppTextStyles.textAlarm,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  TextStyle _getStyle(bool value) {
    return (value)
        ? AppTextStyles.textActionSelected
        : AppTextStyles.textAction;
  }
}

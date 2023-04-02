import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/const/app_typedef.dart';
import 'package:cvetovik/core/ui/custom_text_style_ext.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegionPopup extends StatefulWidget {
  const RegionPopup(
      {Key? key,
      required this.items,
      required this.selected,
      required this.onSelected,
      this.showCancel = true})
      : super(key: key);
  final List<Region> items;
  final String selected;
  final OnSelectedStrAsync onSelected;
  final showCancel;
  @override
  _RegionPopupState createState() => _RegionPopupState();
}

class _RegionPopupState extends State<RegionPopup> {
  @override
  Widget build(BuildContext context) {
    var actions = widget.items
        .map((e) => CupertinoActionSheetAction(
              onPressed: () {
                widget.onSelected(e.title);
                Navigator.pop(context);
              },
              child: Text(
                e.title,
                style: _getStyle(e.title),
              ),
            ))
        .toList();
    return CupertinoActionSheet(
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            AppRes.choiceCity,
            style: Theme.of(context).textTheme.textActionSelected(context),
          ),
        ),
        actions: actions,
        cancelButton: widget.showCancel
            ? CupertinoActionSheetAction(
                isDefaultAction: true,
                child: Text(
                  AppRes.cancel,
                  style: Theme.of(context).textTheme.textAlarm(context),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null);
  }

  TextStyle _getStyle(String title) {
    var isSelected = (title == widget.selected);
    return (isSelected)
        ? Theme.of(context).textTheme.textActionSelected(context)
        : Theme.of(context).textTheme.textAction(context);
  }
}

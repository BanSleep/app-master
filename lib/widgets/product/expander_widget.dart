import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpanderWidget extends StatelessWidget {
  const ExpanderWidget({Key? key, required this.title, required this.child})
      : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      theme: const ExpandableThemeData(
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        tapBodyToCollapse: true,
      ),
      header: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            title,
            style: AppTextStyles.titleLargeSemiBold16,
          )),
      collapsed: Container(),
      expanded: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[child],
      ),
      builder: (_, collapsed, expanded) {
        return Padding(
          padding: EdgeInsets.only(left: 0, right: 0, bottom: 10),
          child: Expandable(
            collapsed: collapsed,
            expanded: expanded,
            theme: const ExpandableThemeData(
                crossFadePoint: 0, iconColor: AppAllColors.lightBlack),
          ),
        );
      },
    );
  }
}

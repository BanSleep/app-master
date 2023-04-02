import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/custom_text_style_ext.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpanderCard extends StatelessWidget {
  const ExpanderCard(
      {Key? key,
      required this.child,
      required this.title,
      required this.headerColor})
      : super(key: key);
  final String title;
  final Widget child;
  final Color headerColor;
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  color: headerColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.text17.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                          ),
                        ),
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            //expandIcon: Icons.arrow_right,
                            //collapseIcon: Icons.arrow_drop_down,
                            iconColor: AppColors.grey,
                            iconSize: 28.0,
                            //iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                collapsed: Container(),
                expanded: child,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

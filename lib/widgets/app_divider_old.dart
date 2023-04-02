import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:flutter/material.dart';

class AppDividerOld extends StatelessWidget {
  const AppDividerOld({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.textArea,
      child: SizedBox(
        height: 10,
        child: Center(
          child: Container(
            height: 5,
            margin: EdgeInsetsDirectional.only(start: 4, end: 4),
            decoration: BoxDecoration(
              color: AppColors.textArea,
              border: Border(
                bottom: Divider.createBorderSide(context,
                    color: AppColors.grey, width: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

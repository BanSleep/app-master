import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/widgets/share/line_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AddInfoCardSheet extends StatelessWidget {
  const AddInfoCardSheet({Key? key, required this.title, required this.desc})
      : super(key: key);
  final String title;
  final String desc;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 8.h,
                bottom: 36.h,
              ),
              child: LineSheet(),
            ),
            Text(
              title.replaceAll('\n', ' '),
              textAlign: TextAlign.start,
              style: AppTextStyles.titleLarge,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 19.0.h,
                bottom: 25.h,
              ),
              child: HtmlWidget(desc),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: SizedBox(
                    height: 44.h,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        style: AppUi.buttonActionStyle,
                        child: Text(
                          AppRes.clear,
                          style: AppTextStyles.titleVerySmall
                              .copyWith(color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

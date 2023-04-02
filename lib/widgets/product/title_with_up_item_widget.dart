import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';

class TitleWithUpItemWidget extends StatelessWidget {
  const TitleWithUpItemWidget({Key? key, required this.title, this.count})
      : super(key: key);
  final String title;
  final String? count;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: title, style: AppTextStyles.titleSmall),
        WidgetSpan(
          child: (count != null)
              ? Transform.translate(
                  offset: const Offset(3, -10),
                  child: Text(count!,
                      //textScaleFactor: 0.7,
                      style: AppTextStyles.textLessMediumBold),
                )
              : Container(),
        )
      ]),
    );
  }
}

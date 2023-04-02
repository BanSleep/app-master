import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class IosDialog extends StatelessWidget {
  const IosDialog({Key? key, required this.okTitle, required this.action})
      : super(key: key);

  final AsyncCallback action;
  final String okTitle;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            await action();
            Navigator.pop(context);
          },
          child: Text(okTitle, style: AppTextStyles.textAlarm),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: Text(AppRes.cancel,
            style: AppTextStyles.textAction
                .copyWith(color: AppAllColors.lightAccent)),
      ),
    );
  }
}

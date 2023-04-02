import 'dart:io';

import 'package:cvetovik/widgets/dialog/app_dialog.dart';
import 'package:cvetovik/widgets/dialog/ios_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformDialog {
  static Future<void> show(
      {required BuildContext context,
      required String okTitle,
      required AsyncCallback action,
      required String droidTitle}) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return IosDialog(
            okTitle: okTitle,
            action: action,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DroidDialog(
            okTitle: okTitle,
            text: droidTitle,
          );
        },
      ).then((value) async {
        if (value) {
          await action();
        }
      });
    }
  }
}

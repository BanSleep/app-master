import 'package:cvetovik/pages/app_startup/app_startup_page.dart';
import 'package:flutter/material.dart';

Future<void> resetAppState(BuildContext context) {
  return Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => AppStartupPage()),
    (route) => false,
  );
}

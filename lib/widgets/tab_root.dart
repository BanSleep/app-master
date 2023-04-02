import 'package:cvetovik/core/services/providers/network_detector_notifier.dart';
import 'package:cvetovik/core/ui/app_theme_observer.dart';
import 'package:cvetovik/core/ui/app_theme_provider.dart';
import 'package:cvetovik/models/app/nav_data.dart';
import 'package:cvetovik/widgets/state/not_connect_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabRoot extends ConsumerWidget with AppThemeObserver {
  final Widget child;
  final NavData? navData;
  TabRoot(this.child, {this.navData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(appThemeStateProvider);
    updateTheme(isDark);
    var network = ref.watch(networkAwareProvider);
    if (network == NetworkStatus.Off) {
      return NotConnectWidget(
        tryAgain: () async {},
      );
    } else {
      //SafeArea
      return MaterialApp(
        navigatorObservers: navData != null ? [navData!.observer] : [],
        navigatorKey: navData != null ? navData!.navKey : null,
        debugShowCheckedModeBanner: false,
        theme: ref.read(appThemeProvider).getAppThemeData(context, isDark),
        home: child,
      );
    }
  }
}

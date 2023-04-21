import 'package:cvetovik/core/ui/app_theme_provider.dart';
import 'package:cvetovik/pages/template_page.dart';
import 'package:cvetovik/widgets/home_tab_navigator.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_startup_model.dart';

class AppStartupPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStartupModelProvider);
    bool isDark = ref.watch(appThemeStateProvider);
    return state.when(
      initializing: () => TemplatePage(body: LoadingWidget()),
      loaded: () {
        return HomeTabNavigator(isDark: isDark);
      },
      error: (String? text) {
        return TemplatePage(
          body: AppErrorWidget(
            text: text,
            tryAgain: () async {
              var model = ref.read(appStartupModelProvider.notifier);
              await model.init();
            },
          ),
        );
      },
    );
  }
}

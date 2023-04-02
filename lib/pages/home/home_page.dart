import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:cvetovik/models/app/nav_data.dart';
import 'package:cvetovik/pages/home/home_content.dart';
import 'package:cvetovik/pages/home/home_model.dart';
import 'package:cvetovik/pages/template_page.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:cvetovik/widgets/tab_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  final NavData? navKey;

  HomePage({this.navKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeModelProvider);
    var model = ref.read(homeModelProvider.notifier);
    return state.when(
        initializing: () => TemplatePage(body: LoadingWidget()),
        loaded: (data) {
          return _buildHome(data, model);
        },
        error: (String? text) {
          return _getError(text, model);
        });
  }

  Widget _buildHome(RegionResponse data, HomeModel model) {
    if (data.result) {
      return TabRoot(
        HomeContent(
          items: data.data.values.toList(),
          model: model,
        ),
        navData: navKey,
      );
    } else {
      return _getError(AppRes.error, model);
    }
  }

  Widget _getError(String? text, HomeModel model) {
    return TemplatePage(
      body: AppErrorWidget(
        text: text,
        tryAgain: () async {
          await model.init();
        },
      ),
    );
  }
}

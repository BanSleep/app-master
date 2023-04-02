import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:cvetovik/pages/home/home_model.dart';
import 'package:cvetovik/pages/template_page.dart';
import 'package:cvetovik/pages/user/personal/personal_area_page.dart';
import 'package:cvetovik/pages/user/personal/personal_start_model.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalStartPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(personalStartModelProvider);
    return state.when(
      initializing: () => TemplatePage(body: LoadingWidget()),
      loaded: (data, info) {
        List<Region> regions = data.data.values.toList();
        return PersonalAreaPage(
          items: regions,
          info: info.data,
        );
      },
      error: (String? text) {
        return _getError(text, ref);
      },
    );
  }

  Widget _getError(String? text, WidgetRef ref) {
    return TemplatePage(
      body: AppErrorWidget(
        text: text,
        tryAgain: () async {
          await ref.read(homeModelProvider.notifier).init();
        },
      ),
    );
  }
}

import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/app/nav_data.dart';
import 'package:cvetovik/models/enums/app/set_key.dart';
import 'package:cvetovik/pages/user/auth/auth_start_page.dart';
import 'package:cvetovik/pages/user/personal/personal_start_page.dart';
import 'package:cvetovik/widgets/tab_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  final NavData? navKey;

  ProfilePage({this.navKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var set = ref.watch(settingsProvider);
    String token = set.getData(SetKey.clientToken);
    print("TOKEN IS ${token}");
    late Widget widget;
    if (token.isNotEmpty) {
      widget = PersonalStartPage();
    } else {
      widget = AuthStartPage();
    }
    return TabRoot(
      widget,
      navData: navKey,
    );
  }
}

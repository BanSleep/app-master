import 'dart:io';

import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/pages/app_startup/app_startup_page.dart';
import 'package:cvetovik/pages/hello_screen/hello_screen.dart';
import 'package:cvetovik/pages/profile/calc_delivery.dart';
import 'package:cvetovik/pages/profile/remove_account/more_about_delivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool get isProd => true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) async {
    // Sentry.captureMessage('appStart');
    // if (Platform.isAndroid) {
    //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    // }
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://1ca6d8701ce745808073ef2d5ce97c7b@o896010.ingest.sentry.io/6075750';
      },
      appRunner: () => runApp(
        ProviderScope(
          overrides: [
            settingsProvider
                .overrideWith((ref) => SettingsService(sharedPreferences)),
          ],
          child: ScreenUtilInit(
            //638
            designSize: Size(320, 693),
            builder: (_, c) {

              return MaterialApp(
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  DefaultWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('ru'),
                ],
                builder: (context, widget) {
                  return MediaQuery(
                    //Setting font does not change with system font size
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  );
                },
                debugShowCheckedModeBanner: false,
                //debugShowMaterialGrid: true,
                home: HelloScreen(),
                //home: MoreAboutDelivery(),
                // home: DeliveryCalculationScreen(address: 'fghjk',),
              );
            },
          ),
        ),
      ),
    );
  });


}

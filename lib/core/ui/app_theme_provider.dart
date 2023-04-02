import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_dark_theme.dart';
import 'package:cvetovik/core/ui/app_ligth_theme.dart';
import 'package:cvetovik/models/enums/app/set_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeProvider = Provider<AppTheme>((ref) {
  return AppTheme();
});

class AppTheme {
  AppTheme();

  ThemeData getAppThemeData(BuildContext context, bool isDarkModeEnabled) {
    return isDarkModeEnabled ? buildDarkTheme() : buildLightTheme();
  }
}

final appThemeStateProvider =
    StateNotifierProvider<AppThemeNotifier, bool>((ref) {
  var set = ref.read(settingsProvider);
  final _isDarkModeEnabled = set.getData(SetKey.isDarkMode);
  return AppThemeNotifier(_isDarkModeEnabled, set);
});

class AppThemeNotifier extends StateNotifier<bool> {
  AppThemeNotifier(this.defaultDarkModeValue, this.set)
      : super(defaultDarkModeValue);
  final bool defaultDarkModeValue;
  final SettingsService set;

  toggleAppTheme() {
    final _isDarkModeEnabled = set.getData(SetKey.isDarkMode);
    final _toggleValue = !_isDarkModeEnabled;
    set.setData<bool>(SetKey.isDarkMode, _toggleValue).whenComplete(() => {
          state = _toggleValue,
        });
  }
}

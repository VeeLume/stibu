import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/feature/app_state/auth_provider.dart';
import 'package:stibu/main.dart';
import 'package:system_theme/system_theme.dart';

class ThemeProvider with ChangeNotifier {
  AccentColor _accentColor = SystemTheme.accentColor.accent.toAccentColor();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  AccentColor get accentColor => _accentColor;

  FluentThemeData get lightTheme => FluentThemeData(
        brightness: Brightness.light,
        accentColor: _accentColor,
      );
  FluentThemeData get darkTheme => FluentThemeData(
        brightness: Brightness.dark,
        accentColor: _accentColor,
      );

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  set accentColor(AccentColor color) {
    _accentColor = color;
    notifyListeners();
    final appwrite = getIt<AppwriteClient>();
    unawaited(
      appwrite.account.getPrefs().then((preferences) {
        preferences.data['accentColor'] = color.toARGB32();
        appwrite.account.updatePrefs(prefs: preferences.data);
      }),
    );
  }

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    final appwrite = getIt<AppwriteClient>();
    unawaited(
      appwrite.account.getPrefs().then((preferences) {
        preferences.data['themeMode'] = mode.index;
        appwrite.account.updatePrefs(prefs: preferences.data);
      }),
    );
  }

  ThemeProvider() {
    final appwrite = getIt<AppwriteClient>();

    getIt<AuthProvider>().addListener(() async {
      final preferences = await appwrite.account.getPrefs();
      if (preferences.data.containsKey('themeMode')) {
        _themeMode = ThemeMode.values[preferences.data['themeMode']];
      }
      if (preferences.data.containsKey('accentColor')) {
        _accentColor = Color(preferences.data['accentColor']).toAccentColor();
      }
    });

    // getIt<Authentication>().isAuthenticated.listen((isAuthenticated) async {
    //   if (isAuthenticated) {
    //     final preferences = await appwrite.account.getPrefs();
    //     if (preferences.data.containsKey('themeMode')) {
    //       _themeMode = ThemeMode.values[preferences.data['themeMode']];
    //     }
    //     if (preferences.data.containsKey('accentColor')) {
    //       _accentColor = Color(preferences.data['accentColor']).toAccentColor();
    //     }
    //   }
    // });
  }
}

import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/feature/app_state/auth_provider.dart';
import 'package:stibu/feature/app_state/print_templates.dart';
import 'package:stibu/feature/app_state/realtime_subscriptions.dart';
import 'package:stibu/feature/app_state/theme.dart';
import 'package:stibu/feature/router/router.dart';
import 'package:stibu/l10n/generated/l10n.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_protocol/url_protocol.dart';

final log = Logger('Stibu');
final getIt = GetIt.instance;

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final deviceLocale = PlatformDispatcher.instance.locale;
  Intl.defaultLocale = deviceLocale.toLanguageTag();
  await initializeDateFormatting(deviceLocale.toLanguageTag());

  await initializeDateFormatting();

  SystemTheme.fallbackColor = const Color(0xFF865432);
  await SystemTheme.accentColor.load();

  GetIt.I.registerSingleton<AppRouter>(AppRouter());
  GetIt.I.registerLazySingleton<AppwriteClient>(
    () => AppwriteClient(
      Client()
          .setEndpoint('https://appwrite.vee.icu/v1')
          .setProject('66ba8a48000da48dd442'),
    ),
  );
  GetIt.I.registerLazySingleton<AuthProvider>(AuthProvider.new);
  GetIt.I.registerLazySingleton<RealtimeSubscriptions>(
    RealtimeSubscriptions.new,
  );
  GetIt.I.registerLazySingleton<ThemeProvider>(ThemeProvider.new);
  GetIt.I.registerLazySingleton<PrintTemplatesProvider>(
    PrintTemplatesProvider.new,
  );

  registerProtocolHandler('stibu');

  Logger.root.level = Level.ALL; // defaults to Level.INFO

  if (kDebugMode) {
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print('${record.level.name}: ${record.time}: ${record.message}');
    });

    getIt<AppwriteClient>().client.setProject('672be8c200098f27fd3a');
  }

  await getIt<AppwriteClient>().locale.get().then((value) {
    log.info('Appwrite locale: $value');
    getIt<AppwriteClient>().client.setLocale(value.countryCode);
  });

  runApp(const StibuApp());
}

class StibuApp extends StatefulWidget {
  const StibuApp({super.key});

  @override
  State<StibuApp> createState() => _StibuAppState();
}

class _StibuAppState extends State<StibuApp> {
  final router = getIt<AppRouter>();
  final authProvider = getIt<AuthProvider>();
  final themeProvider = getIt<ThemeProvider>();


  @override
  void initState() {
    super.initState();
    authProvider.addListener(() async {
      log.info('AuthProvider: isAuthenticated=${authProvider.isAuthenticated}');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: themeProvider,
        builder: (context, child) => FluentApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Stibu',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: router.config(
            reevaluateListenable: authProvider,
            navigatorObservers: () => [RouteLogger()],
          ),
          localizationsDelegates: Lang.localizationsDelegates,
          supportedLocales: Lang.supportedLocales,
        ),
      );
}

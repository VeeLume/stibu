import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/feature/app_state/account.dart';
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
  initializeDateFormatting(deviceLocale.toLanguageTag());

  await initializeDateFormatting();

  SystemTheme.fallbackColor = const Color(0xFF865432);
  await SystemTheme.accentColor.load();

  GetIt.I.registerSingleton<AppRouter>(AppRouter());
  GetIt.I.registerLazySingleton<AppwriteClient>(() => AppwriteClient(
        Client()
            .setEndpoint('https://appwrite.vee.icu/v1')
            .setProject('66ba8a48000da48dd442')
            .setEndPointRealtime('wss://appwrite.vee.icu/v1/realtime'),
      ));
  GetIt.I.registerLazySingleton<Authentication>(() => Authentication());
  GetIt.I.registerLazySingleton<RealtimeSubscriptions>(
      () => RealtimeSubscriptions());
  GetIt.I.registerLazySingleton<ThemeProvider>(() => ThemeProvider());

  registerProtocolHandler("stibu");

  Logger.root.level = Level.ALL; // defaults to Level.INFO

  if (kDebugMode) {
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  FlutterError.onError = (details) {
    log.severe(details.exceptionAsString(), details.exception);
    Sentry.captureException(details.exception, stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log.severe(error, stack);
    Sentry.captureException(error, stackTrace: stack);

    return false;
  };

  SentryFlutter.init((options) {
    options.dsn =
        'https://3bedffb25aaa47afb2daca40cfec9fbb@glitchtip.vee.icu/1'; // if hard coding GlitchTip DSN
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
    // The sampling rate for profiling is relative to tracesSampleRate
    // Setting to 1.0 will profile 100% of sampled transactions:
    // Note: Profiling alpha is available for iOS and macOS since SDK version 7.12.0
    options.profilesSampleRate = 1.0;
  }, appRunner: () => runApp(const StibuApp()));
}

class StibuApp extends StatefulWidget {
  const StibuApp({super.key});

  @override
  State<StibuApp> createState() => _StibuAppState();
}

class _StibuAppState extends State<StibuApp> {
  final router = getIt<AppRouter>();
  final auth = getIt<Authentication>();
  final themeProvider = getIt<ThemeProvider>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) => FluentApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Stibu',
        theme: themeProvider.lightTheme,
        darkTheme: themeProvider.darkTheme,
        themeMode: themeProvider.themeMode,
        routerConfig: router.config(
          reevaluateListenable:
              ReevaluateListenable.stream(auth.isAuthenticated),
          navigatorObservers: () => [RouteLogger()],
        ),
        localizationsDelegates: Lang.localizationsDelegates,
        supportedLocales: Lang.supportedLocales,
      ),
    );
  }
}

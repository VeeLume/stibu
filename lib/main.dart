import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stibu/core/authentication/auth_provider.dart';
import 'package:stibu/providers/register_helper.dart';
import 'package:stibu/router.dart';
import 'package:watch_it/watch_it.dart';

final log = Logger(
  filter: null,
  printer: PrettyPrinter(),
  output: ConsoleOutput(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  di.registerLazySingleton<AppRouter>(() => AppRouter());

  registerServices<AppAuthProvider>(
    () => AppAuthProvider(),
    Client()
        .setEndpoint('https://appwrite.veelume.icu/v1')
        .setProject('682da7b90008b183f859'),
  );
  registerProviders();
  // di.registerLazySingleton<AppwriteClient>(
  //   () => AppwriteClient(
  //     Client()
  //         .setEndpoint('https://appwrite.veelume.icu/v1')
  //         .setProject('682da7b90008b183f859'),
  //   ),
  // );
  // di.registerLazySingletonAsync<AuthProvider>(() async {
  //   final auth = AuthProvider();
  //   await auth.build();
  //   return auth;
  // });
  // di.registerLazySingletonAsync<RealtimeSubscriptions>(() async {
  //   final realtime = di<AppwriteClient>().realtime;
  //   final subscriptions = RealtimeSubscriptions(realtime);
  //   await subscriptions.build();
  //   return subscriptions;
  // });

  // // Providers
  // di.registerLazySingletonAsync<CustomersProvider>(() async {
  //   final provider = CustomersProvider();
  //   await provider.build();
  //   return provider;
  // });
  // di.registerLazySingletonAsync<OrdersProvider>(() async {
  //   final provider = OrdersProvider();
  //   await provider.build();
  //   return provider;
  // });
  // di.registerLazySingletonAsync<CouponsProvider>(() async {
  //   final provider = CouponsProvider();
  //   await provider.build();
  //   return provider;
  // });

  runApp(StibuApp());
}

class StibuApp extends StatefulWidget {
  const StibuApp({super.key});

  @override
  State<StibuApp> createState() => _StibuAppState();
}

class _StibuAppState extends State<StibuApp> {
  final _appRouter = di.get<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Stibu',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}

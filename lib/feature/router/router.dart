// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/feature/app_state/auth_provider.dart';
import 'package:stibu/feature/router/router.gr.dart';
import 'package:stibu/main.dart';

class NoTransitionRoute extends CustomRoute {
  NoTransitionRoute({
    required super.page,
    super.fullscreenDialog,
    super.maintainState,
    super.fullMatch,
    super.guards,
    super.usesPathAsKey,
    super.children,
    super.meta,
    super.title,
    super.path,
    super.keepHistory,
    super.initial,
    super.allowSnapshotting,
    // Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)? transitionsBuilder,
    super.customRouteBuilder,
    // int? durationInMilliseconds,
    // int? reverseDurationInMilliseconds,
    super.opaque = true,
    super.barrierDismissible = true,
    super.barrierLabel,
    super.restorationId,
    super.barrierColor,
  }) : super(
          transitionsBuilder: TransitionsBuilders.noTransition,
          durationInMilliseconds: 0,
          reverseDurationInMilliseconds: 0,
        );
}

const CustomerTab = EmptyShellRoute('CustomerTab');
const RevenueAndExpensesTab = EmptyShellRoute('RevenueAndExpensesTab');
const InvoiceTap = EmptyShellRoute('InvoiceTab');
const ExpenseTab = EmptyShellRoute('ExpenseTab');

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        NoTransitionRoute(
          page: AuthenticationRoute.page,
        ),
        NoTransitionRoute(
          page: ProductKeyRoute.page,
          guards: [AuthGuard()],
        ),
        NoTransitionRoute(
          page: OnboardingRoute.page,
          guards: [AuthGuard()],
        ),
        NoTransitionRoute(
          path: '/',
          page: NavigationScaffoldRoute.page,
          guards: [AuthGuard(), OnboardingGuard(), ValidProductKeyGuard()],
          children: [
            NoTransitionRoute(
              path: 'dashboard',
              page: DashboardRoute.page,
              initial: true,
            ),
            NoTransitionRoute(
              path: 'customers',
              page: CustomerTab,
              children: [
                NoTransitionRoute(
                  path: '',
                  page: CustomerListRoute.page,
                ),
                NoTransitionRoute(
                  path: ':id',
                  page: CustomerDetailRoute.page,
                ),
              ],
            ),
            NoTransitionRoute(
              path: 'invoices',
              page: InvoiceTap,
              children: [
                NoTransitionRoute(
                  path: '',
                  page: InvoiceListRoute.page,
                ),
                NoTransitionRoute(
                  path: ':id',
                  page: InvoiceDetailRoute.page,
                ),
              ],
            ),
            NoTransitionRoute(
              path: 'expenses',
              page: ExpensesListRoute.page,
            ),
            NoTransitionRoute(
              path: 'orders',
              page: OrderListRoute.page,
            ),
            NoTransitionRoute(
              path: 'products',
              page: ProductListRoute.page,
            ),
            NoTransitionRoute(
              page: RevenueAndExpensesTab,
              path: 'revenue-and-expenses',
              children: [
                NoTransitionRoute(
                  page: RevenueAndExpenseOverviewRoute.page,
                  path: '',
                ),
                NoTransitionRoute(
                  page: OverviewYearRoute.page,
                ),
                NoTransitionRoute(
                  page: OverviewMonthRoute.page,
                ),
              ],
            ),
            NoTransitionRoute(
              path: 'calendar',
              page: CalendarRoute.page,
            ),
            NoTransitionRoute(
              path: 'settings',
              page: SettingsRoute.page,
            ),
          ],
        ),
      ];
}

class ValidProductKeyGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final appwrite = getIt<AppwriteClient>();

    try {
      final user = await appwrite.account.get();
      final validProductKey = user.labels.contains('validProductKey');

      log.info('ValidProductKeyGuard: validProductKey=$validProductKey');
      if (validProductKey) {
        resolver.next(true);
      } else {
        await resolver.redirect(
          ProductKeyRoute(
            onFinish: () {
              resolver.next(true);
            },
          ),
        );
      }
    } on AppwriteException catch (e) {
      log.warning(e.message);
      resolver.next(false);
    }
  }
}

class OnboardingGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final appwrite = getIt<AppwriteClient>();

    try {
      final user = await appwrite.account.get();
      final onboardingCompleted =
          user.prefs.data['onboardingCompleted'] ?? false;

      log.info('OnboardingGuard: hasOnboarded=$onboardingCompleted');
      if (onboardingCompleted) {
        resolver.next(true);
      } else {
        await resolver.redirect(
          OnboardingRoute(
            onFinish: () {
              resolver.next(true);
            },
          ),
        );
      }
    } on AppwriteException catch (e) {
      log.warning(e.message);
      resolver.next(false);
    }
  }
}

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final auth = getIt<AuthProvider>();

    log.info('AuthGuard: isAuthenticated=${auth.isAuthenticated}');
    log.info('AuthGuard: isReevaluating=${resolver.isReevaluating}');

    if (auth.isAuthenticated) {
      resolver.next(true);
    } else {
      // Guards are not reevaluated while the redirect is still in progress
      // so we need to to watch for the listenable itself for changes

      late final VoidCallback listener;
      listener = () {
        if (auth.isAuthenticated) {
          auth.removeListener(listener);
          resolver.next(true);
        }
      };
      auth.addListener(listener);

      await resolver.redirect(
        AuthenticationRoute(
          onAuthenticated: (didLogin) =>
              resolver.resolveNext(didLogin, reevaluateNext: false),
        ),
      );
    }
  }
}

class RouteLogger extends AutoRouteObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    log.info('Pushed: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    log.info('Popped: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    log.info(
      'Replaced: ${oldRoute?.settings.name} with ${newRoute?.settings.name}',
    );
  }
}

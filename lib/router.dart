import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/authentication/auth_provider.dart';
import 'package:stibu/main.dart';
import 'package:stibu/router.gr.dart';
import 'package:watch_it/watch_it.dart';

const customerTab = EmptyShellRoute('CustomerTab');
const ordersTab = EmptyShellRoute('OrdersTab');
const couponsTab = EmptyShellRoute('CouponsTab');

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: SignupRoute.page, path: '/signup'),
    AutoRoute(
      page: ScaffoldRouterRoute.page,
      path: '/',
      guards: [AuthGuard()],
      children: [
        AutoRoute(page: DashboardRoute.page, path: 'dashboard', initial: true),
        AutoRoute(
          page: customerTab,
          path: 'customers',
          children: [
            AutoRoute(page: CustomerListRoute.page, path: ''),
            AutoRoute(page: CustomerDetailRoute.page, path: ':id'),
          ],
        ),
        AutoRoute(
          page: ordersTab,
          path: 'orders',
          children: [
            AutoRoute(page: OrderListRoute.page, path: ''),
            AutoRoute(page: OrderDetailRoute.page, path: ':id'),
          ],
        ),
        AutoRoute(
          page: couponsTab,
          path: 'coupons',
          children: [
            AutoRoute(page: CouponListRoute.page, path: ''),
            // AutoRoute(page: CouponDetailRoute.page, path: ':id'),
          ],
        ),
      ],
    ),
  ];
}

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final auth = await di.getAsync<AppAuthProvider>();

    log
      ..d('AuthGuard: isAuthenticated=${auth.isAuthenticated}')
      ..d('AuthGuard: isReevaluating=${resolver.isReevaluating}');

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

      await resolver.redirectUntil(const LoginRoute());
    }
  }
}

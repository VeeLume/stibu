import 'package:auto_route/auto_route.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:stibu/router.gr.dart';

enum Layout { listDetail, supportingPane, feed }

enum LayoutSize { compact, medium, expanded, large, extraLarge }

LayoutSize getLayoutSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) {
    return LayoutSize.compact;
  } else if (width < 840) {
    return LayoutSize.medium;
  } else if (width < 1200) {
    return LayoutSize.expanded;
  } else if (width < 1600) {
    return LayoutSize.large;
  } else {
    return LayoutSize.extraLarge;
  }
}

bool smallLayout(BuildContext context) {
  final size = getLayoutSize(context);
  return size == LayoutSize.compact || size == LayoutSize.medium;
}

int getRecommendedPanes(BuildContext context) {
  final size = getLayoutSize(context);
  switch (size) {
    case LayoutSize.compact:
      return 1;
    case LayoutSize.medium:
      return 1;
    case LayoutSize.expanded:
      return 2;
    case LayoutSize.large:
      return 2;
    case LayoutSize.extraLarge:
      return 3;
  }
}

@RoutePage()
class ScaffoldRouterPage extends StatelessWidget {
  ScaffoldRouterPage({super.key});

  final backgroundColor = Colors.grey[200];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: [
        DashboardRoute(),
        CustomerListRoute(),
        OrderListRoute(),
        CouponListRoute(),
      ],
      builder: (context, child) {
        final router = AutoTabsRouter.of(context);
        final small = smallLayout(context);

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: buildTitleBar(context),
          drawer: buildNavigationDrawer(context),
          body: Row(
            children: [
              if (!small)
                NavigationRail(
                  backgroundColor: backgroundColor,
                  leading: Column(children: [AutoLeadingButton()]),
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text('Customers'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.shopping_cart),
                      label: Text('Orders'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.card_giftcard),
                      label: Text('Coupons'),
                    ),
                  ],
                  selectedIndex: router.activeIndex,
                  onDestinationSelected: (index) {
                    router.setActiveIndex(index);
                  },
                ),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

NavigationDrawer buildNavigationDrawer(BuildContext context) {
  final router = AutoTabsRouter.of(context);
  return NavigationDrawer(
    key: scaffoldKey,
    selectedIndex: router.activeIndex,
    onDestinationSelected: (index) {
      Navigator.pop(context);
      router.setActiveIndex(index);
    },
    children: [
      NavigationDrawerDestination(icon: Icon(Icons.home), label: Text('Home')),
      NavigationDrawerDestination(
        icon: Icon(Icons.person),
        label: Text('Customers'),
      ),
      NavigationDrawerDestination(
        icon: Icon(Icons.shopping_cart),
        label: Text('Orders'),
      ),
      NavigationDrawerDestination(
        icon: Icon(Icons.card_giftcard),
        label: Text('Coupons'),
      ),
    ],
  );
}

// bool _isDesktop() {
//   return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
// }

Scaffold buildScaffold(
  BuildContext context, {
  required AppBar appBar,
  required Widget body,
}) {
  return Scaffold(
    appBar: appBar,
    // drawer: buildNavigationDrawer(context),
    body: body,
  );
}

PreferredSizeWidget buildTitleBar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(56),
    child: Row(
      children: [
        Expanded(
          child: WindowTitleBarBox(
            child: MoveWindow(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Stibu'),
                ),
              ),
            ),
          ),
        ),
        MinimizeWindowButton(),
        MaximizeWindowButton(),
        CloseWindowButton(),
      ],
    ),
  );
}

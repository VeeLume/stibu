import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/feature/app_state/auth_provider.dart';
import 'package:stibu/feature/navigation/windows_appbar.dart';
import 'package:stibu/feature/router/router.dart';
import 'package:stibu/feature/router/router.gr.dart';
import 'package:stibu/main.dart';

class RouteDestination {
  final String title;
  final IconData icon;
  final PageRouteInfo route;
  final Widget? trailing;
  final Widget? infoBadge;
  final MouseCursor? mouseCursor;
  final WidgetStateColor? tileColor;
  final WidgetStateColor? selectedTileColor;
  final bool enabled;
  final List<RouteDestination>? items;

  const RouteDestination({
    required this.title,
    required this.icon,
    required this.route,
    this.trailing,
    this.infoBadge,
    this.mouseCursor,
    this.tileColor,
    this.selectedTileColor,
    this.enabled = true,
    this.items,
  });
}

var items = <Object>[
  const RouteDestination(
    title: 'Dashboard',
    icon: FluentIcons.home,
    route: DashboardRoute(),
  ),
  PaneItemSeparator(),
  RouteDestination(
    title: 'Customers',
    icon: FluentIcons.people,
    route: CustomerTab(),
  ),
  const RouteDestination(
    title: 'Orders',
    icon: FluentIcons.invoice,
    route: OrderListRoute(),
  ),
  const RouteDestination(
    title: 'Invoices',
    icon: FluentIcons.invoice,
    route: InvoiceListRoute(),
  ),
  const RouteDestination(
    title: 'Expenses',
    icon: FluentIcons.money,
    route: ExpensesListRoute(),
  ),
  RouteDestination(
    title: 'Revenue & Expenses',
    icon: FluentIcons.money,
    route: RevenueAndExpensesTab(),
  ),
  const RouteDestination(
    title: 'Products',
    icon: FluentIcons.product,
    route: ProductListRoute(),
  ),
  const RouteDestination(
    title: 'Calendar',
    icon: FluentIcons.calendar,
    route: CalendarRoute(),
  ),
];

var footerItems = <Object>[
  const RouteDestination(
    title: 'Settings',
    icon: FluentIcons.settings,
    route: SettingsRoute(),
  ),
  PaneItemAction(
    icon: const Icon(FluentIcons.sign_out),
    title: const Text('Sign Out'),
    onTap: () => getIt<AuthProvider>().logout(),
  ),
];

List<RouteDestination> flatten(List<Object> items) =>
    items.whereType<RouteDestination>().expand((element) {
      if (element.items != null) {
        return [element, ...element.items!];
      }
      return [element];
    }).toList();

@RoutePage()
class NavigationScaffoldPage extends StatefulWidget {
  const NavigationScaffoldPage({
    super.key,
  });

  @override
  State<NavigationScaffoldPage> createState() => _NavigationScaffoldPageState();
}

class _NavigationScaffoldPageState extends State<NavigationScaffoldPage> {
  ImageProvider? userImage;
  String? userName;
  String? userEmail;

  List<RouteDestination> get routeDestinations =>
      (flatten(items) + flatten(footerItems)).toList(growable: false);


  List<NavigationPaneItem> buildItems(
    List<Object> items,
    int selectedIndex,
    Widget child,
  ) =>
      items.map<NavigationPaneItem>((element) {
        if (element is RouteDestination) {
          if (element.items == null) {
            return PaneItem(
              icon: Icon(element.icon),
              title: Text(element.title),
              body: child,
              trailing: element.trailing,
              infoBadge: element.infoBadge,
              mouseCursor: element.mouseCursor,
              tileColor: element.tileColor,
              selectedTileColor: element.selectedTileColor,
              enabled: element.enabled,
            );
          } else {
            return PaneItemExpander(
              icon: Icon(element.icon),
              title: Text(element.title),
              body: child,
              items: buildItems(element.items!, selectedIndex, child),
              trailing: element.trailing ?? PaneItemExpander.kDefaultTrailing,
              infoBadge: element.infoBadge,
              mouseCursor: element.mouseCursor,
              tileColor: element.tileColor,
              selectedTileColor: element.selectedTileColor,
            );
          }
        } else if (element is NavigationPaneItem) {
          return element;
        }
        throw Exception('Invalid item type');
      }).toList();

  @override
  void initState() {
    unawaited(
      getIt<AppwriteClient>().account.get().then((account) {
        getIt<AppwriteClient>()
            .avatars
            .getInitials(
              name: account.name,
              width: 40,
              height: 40,
            )
            .then((image) {
          setState(() {
            userImage = Image.memory(image).image;
            userName = account.name;
            userEmail = account.email;
          });
        }).catchError((e) {
          log.warning('Failed to get user image: $e');
        });
      }).catchError((e) {
        log.warning('Failed to get account: $e');
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => AutoTabsRouter(
        routes: routeDestinations.map((e) => e.route).toList(),
        homeIndex: 0,
        builder: (context, child) => NavigationView(
          appBar: buildNavigationAppBar(context),
          pane: NavigationPane(
            selected: context.tabsRouter.activeIndex,
            onChanged: (index) => context.tabsRouter.setActiveIndex(index),
            displayMode: PaneDisplayMode.auto,
            header: userImage != null
                ? AccountInfo(
                    image: userImage!,
                    name: userName!,
                    email: userEmail!,
                  )
                : const SizedBox(
                    height: 78,
                    child: Center(child: ProgressBar()),
                  ),
            items: buildItems(items, context.tabsRouter.activeIndex, child),
            footerItems:
                buildItems(footerItems, context.tabsRouter.activeIndex, child),
          ),
        ),
      );
}

class AccountInfo extends StatelessWidget {
  const AccountInfo({
    super.key,
    required this.image,
    required this.name,
    required this.email,
  });

  final ImageProvider image;
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 78,
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: image,
              ),
            ),
              ),
          title: Text(name),
          subtitle: Text(email),
        ),
      );
}

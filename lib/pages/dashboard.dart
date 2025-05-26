import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final small = smallLayout(context);

    if (small) {
      return buildScaffold(
        context,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          title: const Text('Dashboard'),
        ),
        body: const Center(child: Text('Dashboard')),
      );
    }

    return const Center(child: Text('Dashboard'));
  }
}

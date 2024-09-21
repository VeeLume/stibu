import 'package:auto_route/auto_route.dart';
import 'package:fluent_ui/fluent_ui.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Column(
        children: [
          const Center(
            child: Text("Dashboard"),
          ),
          Button(
            child: const Text('Crash App'),
            onPressed: () {
              throw Exception('Crash App');
            },
          )
        ],
      ),
    );
  }
}

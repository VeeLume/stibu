import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/common/models_extensions.dart';
import 'package:stibu/main.dart';

@RoutePage()
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<Products> products = [];

  @override
  void initState() {
    super.initState();
    // Load products
    unawaited(
      Products.page(limit: 250, offset: 0).then((value) {
        log.info('Products: ${value.isSuccess}');
        if (value.isSuccess) {
          setState(() {
            products.addAll(value.success.$2);
          });
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) => ScaffoldPage(
        header: PageHeader(
          title: const Text('Products'),
          commandBar: CommandBar(
            primaryItems: [
              CommandBarButton(
                onPressed: () {},
                icon: const Icon(FluentIcons.add),
              ),
            ],
          ),
        ),
        content: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              title: Text(product.title),
              subtitle: Text(product.description),
              trailing: Text(product.itemPrice.currency.format()),
            );
          },
        ),
      );
}

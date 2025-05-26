import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/list_page.dart';
import 'package:stibu/core/models_extensions.dart';
import 'package:stibu/models/orders.dart';
import 'package:stibu/pages/orders/details.dart';
import 'package:stibu/providers/orders.dart';
import 'package:stibu/router.gr.dart';

@RoutePage()
class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  Widget _searchButton() {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        // showSearch(
        //   context: context,
        //   delegate: OrderSearchDelegate(),
        // );
      },
    );
  }

  Widget _addButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () async {
        final result =
            await Orders(
              customerId: -1,
              customerName: '',
              date: DateTime.now(),
            ).create();

        if (result.isSuccess && context.mounted) {
          context.navigateTo(
            OrderDetailRoute(
              documentId: result.success.$id,
              order: result.success,
            ),
          );
        } else if (result.isFailure && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.failure.message ?? 'Error creating order'),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => ListPage<Orders, OrdersProvider>(
    title: 'Orders',
    navigateToDetailPage: (order) {
      context.navigateTo(OrderDetailRoute(documentId: order.$id, order: order));
    },
    smallLayoutActions: (_, _) => [_addButton(context), _searchButton()],
    listItemBuilder: (order, onItemSelected) {
      return ListTile(
        splashColor: Colors.transparent,
        leading: Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                order.invoice != null
                    ? Theme.of(
                      context,
                    ).primaryColor.withGreen(200).withAlpha(50)
                    : Theme.of(context).primaryColor.withAlpha(25),
          ),
          child: Center(
            child: Text(
              order.invoice != null ? order.invoice!.invoiceNumber : 'Draft',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        title: Text(order.customerName),
        subtitle: Text(order.total.format()),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => onItemSelected(order),
      );
    },
    largeLayoutLeading: (_, _) => _searchButton(),
    largeLayoutActions: (_, _) => [_addButton(context)],
    largeLayoutContent: (order, _) => OrderDetails(order: order),
  );
}

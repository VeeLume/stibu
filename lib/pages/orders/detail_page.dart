import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';
import 'package:stibu/models/orders.dart';
import 'package:stibu/pages/orders/details.dart';
import 'package:stibu/router.gr.dart';

@RoutePage()
class OrderDetailPage extends StatelessWidget {
  final Orders? order;
  final String documentId;
  const OrderDetailPage({
    super.key,
    @PathParam('id') required this.documentId,
    this.order,
  });

  @override
  Widget build(BuildContext context) {
    if (!smallLayout(context)) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.navigateTo(OrderListRoute());
      });
    }

    return order != null
        ? OrderDetails(order: order!)
        : FutureBuilder(
          future: Orders.get(documentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            final order = snapshot.data as Orders;
            return OrderDetails(order: order);
          },
        );
  }
}

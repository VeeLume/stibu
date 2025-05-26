import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';
import 'package:stibu/models/customers.dart';
import 'package:stibu/pages/customers/details.dart';
import 'package:stibu/router.gr.dart';

@RoutePage()
class CustomerDetailPage extends StatelessWidget {
  final String documentId;
  final Customers? customer;
  const CustomerDetailPage({
    super.key,
    @PathParam('id') required this.documentId,
    this.customer,
  });

  @override
  Widget build(BuildContext context) {
    if (!smallLayout(context)) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.navigateTo(CustomerListRoute());
      });
    }

    return customer != null
        ? CustomerDetails(customer: customer!)
        : FutureBuilder(
          future: Customers.get(documentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            return CustomerDetails(customer: snapshot.data as Customers);
          },
        );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';
import 'package:stibu/models/customers.dart';
import 'package:stibu/pages/customers/info_card.dart';
import 'package:stibu/pages/customers/input_dialog.dart';
import 'package:stibu/providers/customers.dart';
import 'package:watch_it/watch_it.dart';

class CustomerDetails extends WatchingWidget {
  final Customers customer;
  const CustomerDetails({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final currentCustomer = watchPropertyValue((CustomersProvider c) {
      return c.items.firstWhere(
        (element) => element.$id == customer.$id,
        orElse: () => customer,
      );
    });

    if (smallLayout(context)) {
      return Scaffold(
        appBar: AppBar(
          leading: AutoLeadingButton(),
          title: Center(child: Text(currentCustomer.name)),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => CustomerInputDialog(
                        customer: currentCustomer,
                        onCustomerCreated: (customer) async {
                          final result = await customer.update();
                          if (result.isSuccess) {
                          } else if (result.isFailure && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result.failure.message ??
                                      'Failed to update customer.',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${currentCustomer.id}'),
              Text('Name: ${currentCustomer.name}'),
              Text('Email: ${currentCustomer.email}'),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          primary: false,
          automaticallyImplyLeading: false,
          elevation: 4,
          actionsPadding: EdgeInsets.only(right: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(28)),
          ),
          title: Center(child: Text(customer.name)),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => CustomerInputDialog(
                        customer: currentCustomer,
                        onCustomerCreated: (customer) async {
                          final result = await customer.update();
                          if (result.isFailure && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result.failure.message ??
                                      'Failed to update customer.',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                );
              },
            ),
          ],
        ),
        CustomerInfoCard(customer: currentCustomer),
        Expanded(child: Placeholder()),
      ],
    );
  }
}

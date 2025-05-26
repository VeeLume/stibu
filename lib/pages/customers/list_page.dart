import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/list_page.dart';
import 'package:stibu/models/customers.dart';
import 'package:stibu/pages/customers/details.dart';
import 'package:stibu/pages/customers/input_dialog.dart';
import 'package:stibu/pages/customers/search.dart';
import 'package:stibu/providers/customers.dart';
import 'package:stibu/router.gr.dart';

@RoutePage()
class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListPage<Customers, CustomersProvider>(
      title: 'Customers',
      navigateToDetailPage:
          (item) => context.navigateTo(
            CustomerDetailRoute(customer: item, documentId: item.$id),
          ),
      listItemBuilder: (item, onItemSelected) {
        return ListTile(
          splashColor: Colors.transparent,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            ),
            child: Center(child: Text(item.id.toString())),
          ),
          title: Text(item.name),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onItemSelected(item),
        );
      },
      largeLayoutLeading:
          (_, onItemSelected) =>
              CustomerSearch(onCustomerSelected: onItemSelected),
      largeLayoutActions:
          (_, onItemSelected) => [_addButton(context, onItemSelected)],
      largeLayoutContent: (customer, _) => CustomerDetails(customer: customer),
      smallLayoutActions:
          (_, onItemSelected) => [
            _addButton(context, onItemSelected),
            CustomerSearch(onCustomerSelected: onItemSelected),
          ],
    );
  }

  IconButton _addButton(
    BuildContext context,
    Function(Customers)? onItemSelected,
  ) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (context) => CustomerInputDialog(
                onCustomerCreated: (customer) async {
                  final result = await customer.create();
                  if (result.isSuccess) {
                    onItemSelected?.call(result.success);
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.failure.message ??
                              'Failed to create customer.',
                        ),
                      ),
                    );
                  }
                },
              ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stibu/models/customers.dart';

class CustomerInfoCard extends StatelessWidget {
  final Customers customer;
  const CustomerInfoCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) => Card(
    child: SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.name),
                Text('ID: ${customer.id}'),
                const Spacer(),
                Text(customer.street ?? ''),
                Text(customer.zip ?? ' ${customer.city}'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (customer.email != null)
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.mail),
                      ),
                      Text(customer.email!),
                    ],
                  ),
                if (customer.phone != null)
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.phone),
                      ),
                      Text(customer.phone!),
                    ],
                  ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

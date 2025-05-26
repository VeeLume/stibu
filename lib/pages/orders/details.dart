import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';
import 'package:stibu/core/products_helper.dart';
import 'package:stibu/models/orders.dart';
import 'package:stibu/pages/orders/product_add_dialog.dart';
import 'package:stibu/providers/orders.dart';
import 'package:watch_it/watch_it.dart';

class OrderDetails extends WatchingWidget {
  final Orders order;
  const OrderDetails({super.key, required this.order});

  Widget _addCouponButton() {
    return TextButton.icon(
      icon: Icon(Icons.add),
      label: Text('Add Coupon'),
      onPressed: () {
        // AutoRouter.of(context).push(
        //   AddCouponToOrderRoute(order: order),
        // );
      },
    );
  }

  Widget _createInvoiceButton() {
    return IconButton(
      icon: Icon(Icons.receipt),
      onPressed: () {
        // AutoRouter.of(context).push(
        //   CreateInvoiceRoute(order: order),
        // );
      },
    );
  }

  Widget _deleteButton() {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('Delete Order'),
        //     content: Text('Are you sure you want to delete this order?'),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.of(context).pop(),
        //         child: Text('Cancel'),
        //       ),
        //       TextButton(
        //         onPressed: () async {
        //           final result = await order.delete();
        //           if (result.isSuccess) {
        //             Navigator.of(context).pop();
        //           } else if (result.isFailure && context.mounted) {
        //             ScaffoldMessenger.of(context).showSnackBar(
        //               SnackBar(
        //                 content: Text(
        //                   result.failure.message ?? 'Failed to delete order.',
        //                 ),
        //               ),
        //             );
        //           }
        //         },
        //         child: Text('Delete'),
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }

  Widget _printDropdown() {
    return PopupMenuButton(
      itemBuilder:
          (context) => [
            PopupMenuItem(value: 'print', child: Text('Print')),
            PopupMenuItem(value: 'email', child: Text('Email')),
          ],
      onSelected: (value) {
        if (value == 'print') {
          // AutoRouter.of(context).push(
          //   PrintOrderRoute(order: order),
          // );
        } else if (value == 'email') {
          // AutoRouter.of(context).push(
          //   EmailOrderRoute(order: order),
          // );
        }
      },
    );
  }

  Widget _editButton() {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        // showDialog(
        //   context: context,
        //   builder:
        //       (context) => OrderInputDialog(
        //         order: currentOrder,
        //         onOrderCreated: (order) async {
        //           final result = await order.update();
        //           if (result.isSuccess) {
        //           } else if (result.isFailure && context.mounted) {
        //             ScaffoldMessenger.of(context).showSnackBar(
        //               SnackBar(
        //                 content: Text(
        //                   result.failure.message ??
        //                       'Failed to update order.',
        //                 ),
        //               ),
        //             );
        //           }
        //         },
        //       ),
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentOrder = watchPropertyValue((OrdersProvider p) {
      return p.items.firstWhere(
        (element) => element.$id == order.$id,
        orElse: () => order,
      );
    });

    final topActions =
        currentOrder.invoice == null
            ? [_deleteButton(), _createInvoiceButton()]
            : [_printDropdown()];

    final bottomActions =
        currentOrder.invoice == null
            ? [AddProductButton(order: order), _addCouponButton()]
            : <Widget>[];

    if (smallLayout(context)) {
      return Scaffold(
        appBar: AppBar(
          leading: AutoLeadingButton(),
          title: Text(
            currentOrder.invoice?.invoiceNumber ??
                currentOrder.date.format('dd.MM.yyyy'),
          ),
          actions: topActions,
        ),
        body: Column(
          children: [
            SizedBox(height: 120, child: Placeholder()),
            AppBar(automaticallyImplyLeading: false, actions: bottomActions),
            Expanded(child: Placeholder()),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          currentOrder.invoice?.invoiceNumber ??
              currentOrder.date.format('dd.MM.yyyy'),
        ),
        actions: topActions,
      ),
      body: Column(
        children: [
          SizedBox(height: 120, child: Placeholder()),
          AppBar(automaticallyImplyLeading: false, actions: bottomActions),
          Expanded(child: Placeholder()),
        ],
      ),
    );
  }
}

class AddProductButton extends StatefulWidget {
  final Orders order;
  const AddProductButton({super.key, required this.order});

  @override
  State<AddProductButton> createState() => _AddProductButtonState();
}

class _AddProductButtonState extends State<AddProductButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon:
          _isLoading
              ? CircularProgressIndicator(
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              )
              : Icon(Icons.add),
      label: Text('Add Product'),
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        final result = await getCurrentProducts();
        setState(() {
          _isLoading = false;
        });
        if (result.isFailure) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(result.failure.message)));
          }
          return;
        }
        if (!context.mounted) {
          return;
        }
        await showAddProductsDialog(context, widget.order, result.success);
      },
    );
  }
}

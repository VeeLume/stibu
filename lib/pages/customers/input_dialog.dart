import 'package:auto_route/auto_route.dart';
import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';
import 'package:stibu/core/new_ids.dart';
import 'package:stibu/models/customers.dart';

class CustomerInputDialog extends StatefulWidget {
  final Customers? customer;
  final void Function(Customers) onCustomerCreated;

  const CustomerInputDialog({
    super.key,
    required this.onCustomerCreated,
    this.customer,
  });

  @override
  State<CustomerInputDialog> createState() => _CustomerInputDialogState();
}

class _CustomerInputDialogState extends State<CustomerInputDialog> {
  final _formKey = GlobalKey<FormState>();
  late int? _id;
  late String? _name = widget.customer?.name;
  late String? _email = widget.customer?.email;
  late String? _phone = widget.customer?.phone;
  late String? _street = widget.customer?.street;
  late String? _zip = widget.customer?.zip;
  late String? _city = widget.customer?.city;

  @override
  void initState() {
    super.initState();
    _id = widget.customer?.id;

    if (_id == null) {
      newCustomerId().then((result) {
        if (result.isSuccess) {
          setState(() {
            _id = result.success;
          });
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.failure.message ?? 'Failed to generate new customer ID.',
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) =>
      smallLayout(context)
          ? Dialog.fullscreen(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text(
                      widget.customer != null
                          ? 'Edit Customer'
                          : 'Create Customer',
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Save'),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            widget.onCustomerCreated(
                              widget.customer != null
                                  ? widget.customer!.copyWith(
                                    name: () => _name!,
                                    email: () => _email?.nullIfBlank,
                                    phone: () => _phone?.nullIfBlank,
                                    street: () => _street?.nullIfBlank,
                                    zip: () => _zip?.nullIfBlank,
                                    city: () => _city?.nullIfBlank,
                                  )
                                  : Customers(
                                    id: _id!,
                                    name: _name!,
                                    email: _email?.nullIfBlank,
                                    phone: _phone?.nullIfBlank,
                                    street: _street?.nullIfBlank,
                                    zip: _zip?.nullIfBlank,
                                    city: _city?.nullIfBlank,
                                  ),
                            );
                            context.pop();
                          }
                        },
                      ),
                    ],
                  ),
                  Text('Customer ID: ${_id ?? 'Generating...'}'),
                  _getForm(),
                ],
              ),
            ),
          )
          : Dialog(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 280, maxWidth: 560),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Customer ID: ${_id ?? 'Generating...'}'),
                    _getForm(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              _formKey.currentState?.save();
                              widget.onCustomerCreated(
                                widget.customer != null
                                    ? widget.customer!.copyWith(
                                      name: () => _name!,
                                      email: () => _email?.nullIfBlank,
                                      phone: () => _phone?.nullIfBlank,
                                      street: () => _street?.nullIfBlank,
                                      zip: () => _zip?.nullIfBlank,
                                      city: () => _city?.nullIfBlank,
                                    )
                                    : Customers(
                                      id: _id!,
                                      name: _name!,
                                      email: _email?.nullIfBlank,
                                      phone: _phone?.nullIfBlank,
                                      street: _street?.nullIfBlank,
                                      zip: _zip?.nullIfBlank,
                                      city: _city?.nullIfBlank,
                                    ),
                              );
                            }
                            context.pop();
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );

  Form _getForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            onSaved: (value) => _name = value,
            validator: (value) {
              if (value.isBlank) {
                return 'Name is required';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            onSaved: (value) => _email = value,
            validator: (value) {
              if (value.isNotBlank && !value.isValidEmail) {
                return 'Invalid email address';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: _phone,
            decoration: const InputDecoration(labelText: 'Phone'),
            onSaved: (value) => _phone = value,
          ),
          TextFormField(
            initialValue: _street,
            decoration: const InputDecoration(labelText: 'Street'),
            onSaved: (value) => _street = value,
          ),
          TextFormField(
            initialValue: _zip,
            decoration: const InputDecoration(labelText: 'Zip'),
            onSaved: (value) => _zip = value,
          ),
          TextFormField(
            initialValue: _city,
            decoration: const InputDecoration(labelText: 'City'),
            onSaved: (value) => _city = value,
          ),
        ],
      ),
    );
  }
}

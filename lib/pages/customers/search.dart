import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';
import 'package:stibu/models/customers.dart';

class CustomerSearch extends StatefulWidget {
  final void Function(Customers) onCustomerSelected;

  const CustomerSearch({super.key, required this.onCustomerSelected});

  @override
  State<CustomerSearch> createState() => _CustomerSearchState();
}

class _CustomerSearchState extends State<CustomerSearch> {
  final _searchController = SearchController();
  final List<Customers> _searchResults = [];
  Timer? _debounce;

  Future<void> _search(String query) async {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 50), () async {
      final List<Customers> results = [];
      bool hasMore = true;
      do {
        final result = await Customers.page(
          offset: results.isEmpty ? 0 : null,
          last: results.isEmpty ? null : results.last,
          queries: [Query.search('name', query)],
        );

        if (result.isSuccess) {
          results.addAll(result.success.$2);
          hasMore = results.length < result.success.$1;
        }
      } while (hasMore);

      setState(() {
        _searchResults.clear();
        _searchResults.addAll(results);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() async {
      await _search(_searchController.text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SearchAnchor(
    searchController: _searchController,
    isFullScreen: smallLayout(context),
    builder:
        (context, controller) => IconButton(
          icon: const Icon(Icons.search),
          onPressed: controller.openView,
        ),
    suggestionsBuilder:
        (context, controller) =>
            List<ListTile>.generate(_searchResults.length, (index) {
              final customer = _searchResults[index];
              return ListTile(
                title: Text(customer.name),
                onTap: () {
                  widget.onCustomerSelected(customer);
                  controller.closeView(null);
                },
              );
            }),
  );
}

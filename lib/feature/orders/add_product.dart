import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show VerticalDivider;
import 'package:flutter/services.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/common/currency.dart';
import 'package:stibu/common/models_extensions.dart';
import 'package:stibu/common/products_helper.dart';
import 'package:stibu/common/show_result_info.dart';

class AddProductsDialog extends StatefulWidget {
  const AddProductsDialog({super.key});

  @override
  State<AddProductsDialog> createState() => _AddProductsDialogState();
}

class _AddProductsDialogState extends State<AddProductsDialog> {
  Map<Products, int> selectedProductsQty = {};
  final _suggestBoxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final porductsFuture = getCurrentProducts();
    _suggestBoxController.clear();

    return ContentDialog(
      title: const Text('Add Products'),
      constraints: const BoxConstraints(maxWidth: 900),
      content: FutureBuilder(
        future: porductsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isFailure) {
              return Center(
                child: SingleChildScrollView(
                    child: Text(snapshot.data!.failure.toString())),
              );
            }

            final products = snapshot.data!.success;

            return Column(
              children: [
                ProductSearch(
                  products: products,
                  onProductAdded: (product, qty) {
                    setState(() {
                      if (selectedProductsQty.containsKey(product)) {
                        selectedProductsQty[product] =
                            selectedProductsQty[product]! + qty;
                      } else {
                        selectedProductsQty[product] = qty;
                      }
                    });
                  },
                ),
                const StrongDivider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: AutoSuggestBox<Products>(
                    controller: _suggestBoxController,
                    trailingIcon: const Icon(FluentIcons.search),
                    textInputAction: TextInputAction.search,
                    placeholder: 'Search for a product',
                    onSelected: (item) {
                      setState(() {
                        if (selectedProductsQty.containsKey(item.value!)) {
                          selectedProductsQty[item.value!] =
                              selectedProductsQty[item.value]! + 1;
                        } else {
                          selectedProductsQty[item.value!] = 1;
                        }
                      });
                    },
                    items: products
                        .map((product) => AutoSuggestBoxItem<Products>(
                              label: "${product.id} - ${product.title}",
                              value: product,
                              child: Tooltip(
                                message: product.title,
                                style: const TooltipThemeData(
                                  waitDuration: Duration(milliseconds: 300),
                                ),
                                child: Text(
                                  "${product.id} - ${product.title}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const StrongDivider(),
                const Text('Currently selected products:'),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: selectedProductsQty.keys.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final product = selectedProductsQty.keys.elementAt(index);
                    final qty = selectedProductsQty.values.elementAt(index);

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child:
                          // Image
                          Container(
                        decoration: product.imageUrl == null
                            ? null
                            : BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(product.imageUrl!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  qty.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.id.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(FluentIcons.delete),
                                onPressed: () {
                                  setState(() {
                                    selectedProductsQty.remove(product);
                                  });
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(4.0)),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.title,
                                  textWidthBasis: TextWidthBasis.longestLine,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }

          return const Center(child: ProgressBar());
        },
      ),
      actions: [
        Button(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        Button(
          onPressed: () {
            Navigator.of(context).pop(selectedProductsQty.entries
                .map((entry) => OrderProducts(
                      id: entry.key.id,
                      title: entry.key.title,
                      quantity: entry.value,
                      price: entry.key.itemPrice,
                    ))
                .toList());
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

Future<void> showAddProductsDialog(BuildContext context, Orders order) async {
  final result = await showDialog<List<OrderProducts>>(
    context: context,
    builder: (context) => const AddProductsDialog(),
  );

  if (result != null) {
    final newProducts = List<OrderProducts>.from(order.products ?? [])
      ..addAll(result);
    final newOrder = order.copyWith(products: newProducts);

    await newOrder.update().then((value) {
      showResultInfo(context, value,
          successMessage: 'Added ${result.length} products to order');
    });
  }
}

class ProductSearch extends StatefulWidget {
  final List<Products> products;
  final void Function(Products product, int qty)? onProductAdded;

  const ProductSearch({
    super.key,
    required this.products,
    this.onProductAdded,
  });

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  int _currentQty = 1;
  Products? _currentProduct;
  final _idController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');

  void _onProductAdded() {
    if (_currentProduct != null) {
      widget.onProductAdded?.call(_currentProduct!, _currentQty);
    }
    setState(() {
      _idController.clear();
      _currentProduct = null;
      _currentQty = 1;
    });
  }

  void _onProductAddedUnlisted() {
    if (_idController.text.isNotEmpty) {
      final id = int.tryParse(_idController.text);

      if (id != null) {
        widget.onProductAdded?.call(
          createUnlistedProduct(
            id,
            'Unlisted Product',
            Currency(0),
          ),
          _currentQty,
        );
      }

      setState(() {
        _idController.clear();
        _currentProduct = null;
        _currentQty = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Column(
              children: [
                TextBox(
                  controller: _idController,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Product ID:'),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onEditingComplete: _onProductAdded,
                  onChanged: (value) async {
                    final id = int.tryParse(value);

                    if (id == null) {
                      return;
                    }

                    final product = widget.products.firstWhereOrNull(
                      (element) => element.id == id,
                    );

                    if (product != null) {
                      setState(() {
                        _currentProduct = product;
                      });
                    } else {
                      setState(() {
                        _currentProduct = null;
                      });
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextBox(
                    controller: _qtyController,
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Quantity:'),
                    ),
                    onChanged: (value) => setState(() {
                      _currentQty = int.tryParse(value) ?? 1;
                    }),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(FluentIcons.add),
                      onPressed: _onProductAdded,
                    ),
                    Button(
                      onPressed: _onProductAddedUnlisted,
                      child: const Text('As Unlisted'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          if (_currentProduct != null)
            SizedBox(
              width: 150,
              height: 150,
              child: _currentProduct!.imageUrl != null
                  ? Image(image: NetworkImage(_currentProduct!.imageUrl!))
                  : const Center(child: Text('No image')),
            ),
          Expanded(
            child: _currentProduct == null
                ? const Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No product found'),
                      ProgressBar(),
                    ],
                  ))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_currentProduct!.title,
                            style: FluentTheme.of(context).typography.subtitle),
                        Text(
                          _currentProduct!.description,
                          overflow: TextOverflow.fade,
                          maxLines: 4,
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "$_currentQty x ${_currentProduct!.itemPrice.currency.format()} = ${(_currentProduct!.itemPrice * _currentQty).currency.format()}",
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class StrongDivider extends StatelessWidget {
  final double verticalPadding;
  final Color color;

  const StrongDivider({
    super.key,
    this.verticalPadding = 10,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Divider(
        style: DividerThemeData(
            horizontalMargin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: color,
            )),
      ),
    );
  }
}
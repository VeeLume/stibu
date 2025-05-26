import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';
import 'package:stibu/core/currency.dart';
import 'package:stibu/core/models_extensions.dart';
import 'package:stibu/core/products_helper.dart';
import 'package:stibu/main.dart';
import 'package:stibu/models/collections.dart';
import 'package:stibu/models/order_products.dart';
import 'package:stibu/models/orders.dart';
import 'package:stibu/models/products.dart';

class AddProductsDialog extends StatefulWidget {
  final List<Products> products;
  const AddProductsDialog({super.key, required this.products});

  @override
  State<AddProductsDialog> createState() => _AddProductsDialogState();
}

class _AddProductsDialogState extends State<AddProductsDialog> {
  final List<OrderProducts> selectedProducts = [];
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController(text: '1');
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Products? _currentProduct;
  int _currentQty = 1;

  @override
  Widget build(BuildContext context) {
    return smallLayout(context)
        ? Dialog.fullscreen(
          child: _buildDialogContent(context, true, const EdgeInsets.all(16)),
        )
        : Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: _buildDialogContent(context, false, const EdgeInsets.all(24)),
        );
  }

  Widget _buildDialogContent(
    BuildContext context,
    bool fullscreen,
    EdgeInsetsGeometry padding,
  ) {
    return Container(
      constraints: BoxConstraints(minWidth: 280, maxWidth: 560),
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fullscreen)
            AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Add Products'),
              actions: [
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if (selectedProducts.isNotEmpty) {
                      Navigator.of(context).pop(selectedProducts);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No products selected')),
                      );
                    }
                  },
                ),
              ],
            ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'Product ID:'),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) async {
                    final id = int.tryParse(value);
                    if (id == null) {
                      setState(() {
                        _currentProduct = null;
                      });
                      return;
                    }
                    final product = widget.products.firstWhereOrNull(
                      (element) => element.id == id,
                    );
                    setState(() {
                      _currentProduct = product;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _qtyController,
                  decoration: InputDecoration(labelText: 'Quantity:'),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    setState(() {
                      _currentQty = int.tryParse(value) ?? 1;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              TextButton(onPressed: _onProductAdded, child: const Text('Add')),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _onProductAddedUnlisted,
                child: const Text('As Unlisted'),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.restart_alt),
                onPressed: () {
                  setState(() {
                    _idController.clear();
                    _currentProduct = null;
                    _currentQty = 1;
                    _qtyController.text = '1';
                    _searchController.clear();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              return RawAutocomplete<Products>(
                textEditingController: _searchController,
                focusNode: _searchFocusNode,
                fieldViewBuilder: (
                  context,
                  textEditingController,
                  focusNode,
                  onFieldSubmitted,
                ) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(labelText: 'Search Product'),
                    onChanged: (value) {
                      setState(() {
                        _currentProduct = null;
                      });
                    },
                  );
                },
                onSelected: (product) {
                  setState(() {
                    _currentProduct = product;
                    _idController.text = product.id.toString();
                    _searchController.text = "";
                    _searchFocusNode.unfocus();
                  });
                },
                optionsBuilder:
                    (textEditingValue) =>
                        widget.products
                            .where(
                              (element) => element.title.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              ),
                            )
                            .toList(),
                displayStringForOption:
                    (option) => '${option.id} - ${option.title}',
                optionsViewBuilder: (context, onSelected, options) {
                  log.d(
                    'Constraints: ${constraints.maxHeight} - ${constraints.maxWidth}',
                  );
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: (MediaQuery.of(context).size.height - 250)
                              .clamp(kMinInteractiveDimension, double.infinity),
                          maxWidth: constraints.maxWidth,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                            right: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                            bottom: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text('${option.id} - ${option.title}'),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          if (_currentProduct != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                children: [
                  if (_currentProduct!.imageUrl != null)
                    Image.network(
                      _currentProduct!.imageUrl!,
                      width: 150,
                      height: 150,
                    )
                  else
                    const SizedBox(
                      width: 150,
                      height: 150,
                      child: Center(child: Text('No image')),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentProduct!.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentProduct!.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 6,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_currentQty x ${_currentProduct!.itemPrice.currency.format()} = ${(_currentProduct!.itemPrice * _currentQty).currency.format()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else if (_idController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Product not found',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: selectedProducts.length,
              itemBuilder: (context, index) {
                final product = selectedProducts[index];
                return ProductPreviewContainer(
                  product: widget.products.firstWhere(
                    (element) => element.id == product.id,
                    orElse:
                        () => createUnlistedProduct(
                          product.id,
                          'Unlisted Product',
                          Currency(0),
                        ),
                  ),
                  quantity: product.quantity,
                  onDelete: () {
                    setState(() {
                      selectedProducts.removeAt(
                        selectedProducts.indexOf(product),
                      );
                    });
                  },
                );
              },
            ),
          ),
          if (!fullscreen)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(selectedProducts),
                  child: const Text('Save'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _onProductAdded() {
    if (_currentProduct != null) {
      final index = selectedProducts.indexWhere(
        (element) => element.id == _currentProduct!.id,
      );
      if (index != -1) {
        setState(() {
          selectedProducts[index] = selectedProducts[index].copyWith(
            quantity: () => selectedProducts[index].quantity + _currentQty,
          );
        });
      } else {
        setState(() {
          selectedProducts.add(
            OrderProducts(
              id: _currentProduct!.id,
              title: _currentProduct!.title,
              quantity: _currentQty,
              price: _currentProduct!.itemPrice,
            ),
          );
        });
      }
      _idController.clear();
      _qtyController.text = '1';
      _currentProduct = null;
      _currentQty = 1;
    }
  }

  void _onProductAddedUnlisted() {
    if (_idController.text.isNotEmpty) {
      final id = int.tryParse(_idController.text);
      if (id != null) {
        setState(() {
          selectedProducts.add(
            OrderProducts(
              id: id,
              title: 'Unlisted Product',
              quantity: _currentQty,
              price: Currency(0).asInt,
            ),
          );
        });
      }
      _idController.clear();
      _qtyController.text = '1';
      _currentProduct = null;
      _currentQty = 1;
    }
  }
}

class ProductPreviewContainer extends StatelessWidget {
  final Products product;
  final int quantity;
  final void Function() onDelete;

  const ProductPreviewContainer({
    super.key,
    required this.product,
    required this.quantity,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor =
        theme.brightness == Brightness.dark
            ? Colors.black.withValues(alpha: .8)
            : Colors.white.withValues(alpha: .8);
    final textColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        decoration:
            product.imageUrl == null
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
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  quantity.toString(),
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  product.id.toString(),
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  hoverColor: Colors.transparent,
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  product.title,
                  textWidthBasis: TextWidthBasis.longestLine,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showAddProductsDialog(
  BuildContext context,
  Orders order,
  List<Products> products,
) async {
  final result = await showDialog<List<OrderProducts>>(
    context: context,
    builder: (context) => AddProductsDialog(products: products),
  );

  if (result != null) {
    // Add the new products to the order
    // if the product is already in the order, update the quantity

    final Map<int, OrderProducts> productsMap = {
      for (final product in order.products) product.id: product,
    };

    for (final newProduct in result) {
      if (productsMap.containsKey(newProduct.id)) {
        productsMap[newProduct.id] = productsMap[newProduct.id]!.copyWith(
          quantity:
              () => productsMap[newProduct.id]!.quantity + newProduct.quantity,
        );
      } else {
        productsMap[newProduct.id] = newProduct;
      }
    }

    final newOrder = order.copyWith(
      products: () => productsMap.values.toList(),
    );

    await newOrder
        .update(
          context: RelationContext(
            includeId: false,
            children: {
              'coupons': RelationContext(),
              'products': RelationContext(),
            },
          ),
        )
        .then((value) {
          if (value.isFailure && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  value.failure.message ?? 'Failed to update order.',
                ),
              ),
            );
          }
        });
  }
}

class ProductSearch extends StatefulWidget {
  final List<Products> products;
  final void Function(Products product, int qty)? onProductAdded;

  const ProductSearch({super.key, required this.products, this.onProductAdded});

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
          createUnlistedProduct(id, 'Unlisted Product', Currency(0)),
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
  Widget build(BuildContext context) => SizedBox(
    height: 160,
    width: 900,
    child: Row(
      children: [
        SizedBox(
          width: 200,
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(label: const Text('Product ID:')),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                child: TextFormField(
                  controller: _qtyController,
                  decoration: InputDecoration(label: const Text('Quantity:')),
                  onChanged:
                      (value) => setState(() {
                        _currentQty = int.tryParse(value) ?? 1;
                      }),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _onProductAdded,
                  ),
                  TextButton(
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
            child:
                _currentProduct!.imageUrl != null
                    ? Image(image: NetworkImage(_currentProduct!.imageUrl!))
                    : const Center(child: Text('No image')),
          ),
        Expanded(
          child:
              _currentProduct == null
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_currentProduct!.title),
                        Text(
                          _currentProduct!.description,
                          overflow: TextOverflow.fade,
                          maxLines: 6,
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$_currentQty x ${_currentProduct!.itemPrice.currency.format()} = ${(_currentProduct!.itemPrice * _currentQty).currency.format()}',
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

import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:open_filex/open_filex.dart';
import 'package:result_type/result_type.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/common/is_large_screen.dart';
import 'package:stibu/common/scroll_to_index.dart';
import 'package:stibu/common/show_result_info.dart';
import 'package:stibu/feature/app_state/realtime_subscriptions.dart';
import 'package:stibu/feature/orders/list_detail.dart';
import 'package:stibu/feature/orders/list_entry.dart';
import 'package:stibu/feature/pdf_creation/typst.dart';
import 'package:stibu/feature/router/router.gr.dart';
import 'package:stibu/main.dart';
import 'package:stibu/widgets/command_bar_print_button.dart';
import 'package:stibu/widgets/picker.dart';

@RoutePage()
class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  int? selectedIndex;
  Orders? selectOrder;

  final _orders = <Orders>[];
  int _totalOders = 0;
  StreamSubscription? _orderSubscription;
  final _scrollController = ScrollController();

  Future<void> _loadOrders() async {
    late final (int, List<Orders>) result;
    if (_orders.isEmpty) {
      result = (await Orders.page(offset: 0)).success;
    } else {
      result = (await Orders.page(last: _orders.last)).success;
    }
    setState(() {
      _totalOders = result.$1;
      _orders.addAll(result.$2);
    });
  }

  Future<bool> markInvoiceReadOnly(Invoices invoice) async {
    if (invoice.canUpdate) {
      final appwrite = getIt<AppwriteClient>();
      final user = await appwrite.account.get();

      try {
        await appwrite.databases.updateDocument(
          databaseId: Invoices.collectionInfo.databaseId,
          collectionId: Invoices.collectionInfo.$id,
          documentId: invoice.$id,
          permissions: [Permission.read(Role.user(user.$id))],
        );
      } catch (e) {
        if (mounted) {
          await showResultInfo(context, Failure(e.toString()));
        }
        return false;
      }
    }
    return true;
  }

  void _processEvent(RealtimeUpdateType type, Orders item) {
    switch (type) {
      case RealtimeUpdateType.create:
        setState(() {
          _orders.add(item);
        });
      case RealtimeUpdateType.update:
        final index = _orders.indexWhere((e) => e.$id == item.$id);
        if (index != -1) {
          setState(() {
            _orders[index] = item;
          });
        }
      case RealtimeUpdateType.delete:
        _orders.removeWhere((e) => e.$id == item.$id);
        setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    unawaited(_loadOrders());

    final realtime = getIt<RealtimeSubscriptions>();
    _orderSubscription = realtime.ordersUpdates
        .listen((event) => _processEvent(event.type, event.item));
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _orderSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final largeScreen = isLargeScreen(context);
    selectedIndex = largeScreen ? selectedIndex : null;

    if (selectOrder != null) {
      final index = _orders.indexWhere((e) => e.$id == selectOrder!.$id);
      if (index != -1) {
        selectedIndex = index;
        selectOrder = null;
      }
    }

    if (selectedIndex != null && _orders.length <= selectedIndex!) {
      selectedIndex = null;
    }

    if (selectedIndex != null) {
      unawaited(scrollToIndex(selectedIndex!, controller: _scrollController));
    }

    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Orders'),
        commandBar: CommandBar(
          mainAxisAlignment: MainAxisAlignment.end,
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: const Text('New'),
              onPressed: () async {
                final order = await displayNewOrderDialog(context);
                if (order != null) {
                  setState(() {
                    selectOrder = order;
                  });
                }
              },
            ),
            if (selectedIndex != null && _orders[selectedIndex!].canDelete) ...[
              CommandBarButton(
                icon: const Icon(FluentIcons.delete),
                label: const Text('Delete'),
                onPressed: () async {
                  final index = selectedIndex;
                  setState(() {
                    selectedIndex = null;
                  });

                  await _orders[index!].delete().then((value) {
                    context.mounted
                        ? showResultInfo(context, value).then((_) {
                            if (value.isFailure) {
                              setState(() {
                                selectedIndex = index;
                              });
                            }
                          })
                        : null;
                  });
                },
              ),
            ],
            if (selectedIndex != null &&
                _orders[selectedIndex!].invoice != null)
              CommandBarPrintButton(
                title: const Text('Print Invoice'),
                type: PrintTemplatesType.invoiceWithOrder,
                onPressed: (template) async {
                  final invoice =
                      (await Invoices.get(_orders[selectedIndex!].invoice!.$id))
                          .success;

                  final isOK = await markInvoiceReadOnly(invoice);
                  if (!isOK) return;

                  final result = await createPdf(template, invoice);

                  if (result.isFailure && context.mounted) {
                    await showResultInfo(context, result);
                  } else {
                    await OpenFilex.open(result.success.path);
                  }
                },
              ),
          ],
        ),
      ),
      content: Row(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemExtent: 58,
              itemCount: _totalOders > _orders.length
                  ? _orders.length + 1
                  : _orders.length,
              itemBuilder: (context, index) {
                if (index >= _orders.length) {
                  unawaited(_loadOrders());
                  return const Center(child: ProgressBar());
                }

                final order = _orders[index];
                final invoice = order.invoice;

                return OrderListEntry(
                  invoice: invoice,
                  order: order,
                  selected: selectedIndex == index,
                  onPressed: () async {
                    if (!largeScreen) {
                      await context.navigateTo(OrderDetailRoute(id: order.$id));
                    }

                    if (selectedIndex == index) return;

                    setState(() {
                      selectedIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          if (largeScreen && selectedIndex != null)
            Expanded(
              child: Column(
                children: [
                  OrderInfoCard(order: _orders[selectedIndex!]),
                  Expanded(
                    child: OrderProductsList(
                      order: _orders[selectedIndex!],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

Future<Orders?> displayNewOrderDialog(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => const NewOrderDialog(),
    );

class NewOrderDialog extends StatefulWidget {
  const NewOrderDialog({
    super.key,
  });

  @override
  State<NewOrderDialog> createState() => _NewOrderDialogState();
}

class _NewOrderDialogState extends State<NewOrderDialog> {
  DateTime selectedDate = DateTime.now();
  Customers? selectedCustomer;
  final List<Customers> _customers = [];
  Timer? _debounce;
  final _formKey = GlobalKey<FormState>();

  void _loadCustomers(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 50), () {
      final appwrite = getIt<AppwriteClient>();

      unawaited(
        appwrite.databases.listDocuments(
          databaseId: Customers.collectionInfo.databaseId,
          collectionId: Customers.collectionInfo.$id,
          queries: [
            Query.search('name', query),
          ],
        ).then((result) {
          final items = result.documents.map(Customers.fromAppwrite);
          final newItems =
              items.where((e) => !_customers.any((c) => c.$id == e.$id));
          setState(() {
            _customers.addAll(newItems);
          });
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) => ContentDialog(
        title: const Text('New Order'),
        actions: [
          Button(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                final order = Orders(
                  customerId: selectedCustomer!.id,
                  customerName: selectedCustomer!.name,
                  date: selectedDate.toUtc(),
                );

                final user = await getIt<AppwriteClient>().account.get();

                final result = await order.copyWith(
                  $permissions: [
                    Permission.read(Role.user(user.$id)),
                    Permission.write(Role.user(user.$id)),
                  ],
                ).create();

                if (!context.mounted) return;
                await showResultInfo(context, result);

                if (!context.mounted) return;
                Navigator.of(context).pop(order);
              }
            },
            child: const Text('Save'),
          ),
          Button(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
        content: Form(
          key: _formKey,
          child: ListView(
            children: [
              FormDatePicker(
                header: 'Select Order Date',
                initialValue: selectedDate,
                onSaved: (value) => selectedDate = value,
              ),
              const SizedBox(height: 16),
              AutoSuggestBox<Customers>.form(
                placeholder: 'Select Customer',
                textInputAction: TextInputAction.search,
                onSelected: (item) {
                  selectedCustomer = item.value;
                },
                onChanged: (text, reason) {
                  if (reason == TextChangedReason.userInput) {
                    _loadCustomers(text);
                  }
                },
                items: _customers
                    .map(
                      (e) => AutoSuggestBoxItem(
                        label: e.name,
                        value: e,
                      ),
                    )
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a customer';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );
}

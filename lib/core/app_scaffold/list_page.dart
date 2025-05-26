import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';
import 'package:stibu/providers/generic_list_provider.dart';
import 'package:watch_it/watch_it.dart';

class ListPage<T, L extends GenericListProvider<T>> extends StatefulWidget {
  /// A generic list page that can be used to display a list of items.

  final String title;
  final void Function(T item)? navigateToDetailPage;
  final List<Widget> Function(T? item, void Function(T item) onItemSelected)?
  smallLayoutActions;
  final Widget Function(T? item, void Function(T item) onItemSelected)?
  largeLayoutLeading;
  final List<Widget> Function(T? item, void Function(T item) onItemSelected)?
  largeLayoutActions;
  final Widget Function(T item, void Function(T item) onItemSelected)
  listItemBuilder;
  final Widget Function(T item, void Function(T item) onItemSelected)
  largeLayoutContent;

  const ListPage({
    super.key,
    required this.title,
    this.navigateToDetailPage,
    this.smallLayoutActions,
    this.largeLayoutLeading,
    this.largeLayoutActions,
    required this.listItemBuilder,
    required this.largeLayoutContent,
  });

  @override
  State<ListPage> createState() => _ListPageState<T, L>();
}

class _ListPageState<T, L extends GenericListProvider<T>>
    extends State<ListPage<T, L>> {
  T? _selectedItem;

  @override
  Widget build(BuildContext context) {
    final small = smallLayout(context);

    if (small) {
      if (_selectedItem != null) {
        widget.navigateToDetailPage?.call(_selectedItem as T);
      }

      return buildScaffold(
        context,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          title: Text(widget.title),
          actions:
              widget.smallLayoutActions != null
                  ? widget.smallLayoutActions!(_selectedItem as T, (item) {
                    setState(() {
                      _selectedItem = item;
                    });
                  })
                  : [],
        ),
        body: ItemList<T, L>(
          onItemSelected: (item) {
            setState(() {
              _selectedItem = item;
            });
          },
          itemBuilder: widget.listItemBuilder,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Card(
              elevation: 1,
              child: SizedBox(
                width: 360,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: AppBar(
                        primary: false,
                        elevation: 4,
                        actionsPadding: EdgeInsets.only(right: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        leading:
                            widget.largeLayoutLeading != null
                                ? widget.largeLayoutLeading!(_selectedItem, (
                                  item,
                                ) {
                                  setState(() {
                                    _selectedItem = item;
                                  });
                                })
                                : null,
                        title: Text(widget.title),
                        actions:
                            widget.largeLayoutActions != null
                                ? widget.largeLayoutActions!(_selectedItem, (
                                  item,
                                ) {
                                  setState(() {
                                    _selectedItem = item;
                                  });
                                })
                                : [],
                      ),
                    ),
                    Expanded(
                      child: ItemList<T, L>(
                        onItemSelected: (item) {
                          setState(() {
                            _selectedItem = item;
                          });
                        },
                        itemBuilder: widget.listItemBuilder,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child:
                  _selectedItem != null
                      ? widget.largeLayoutContent(_selectedItem as T, (item) {
                        setState(() {
                          _selectedItem = item;
                        });
                      })
                      : Center(child: Text("No Item selected")),
            ),
          ],
        ),
      );
    }
  }
}

class ItemList<T, L extends GenericListProvider<T>>
    extends WatchingStatefulWidget {
  final void Function(T item) onItemSelected;
  final Widget Function(T item, void Function(T item) onItemSelected)
  itemBuilder;

  const ItemList({
    super.key,
    required this.onItemSelected,
    required this.itemBuilder,
  });

  @override
  State<ItemList> createState() => _ItemListState<T, L>();
}

class _ItemListState<T, L extends GenericListProvider<T>>
    extends State<ItemList<T, L>> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (!isReady<L>()) {
      return const Center(child: CircularProgressIndicator());
    }

    final provider = watchIt<L>();

    return ListView.builder(
      controller: _scrollController,
      itemCount: provider.items.length + (provider.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= provider.items.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final item = provider.items[index];
        return widget.itemBuilder(item, widget.onItemSelected);
      },
    );
  }
}

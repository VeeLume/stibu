// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/foundation.dart' as _i1;
import 'package:stibu/providers/generic_list_provider.dart' as _i2;
import 'package:stibu/models/product_keys.dart' as _i3;
import 'package:watch_it/watch_it.dart' as _i4;
import 'package:stibu/providers/realtime_subscription.dart' as _i5;
import 'package:appwrite/models.dart' as _i6;

class ProductKeysProvider extends _i1.ChangeNotifier
    implements _i2.GenericListProvider<_i3.ProductKeys> {
  final List<_i3.ProductKeys> _items = [];

  int _totalItems = 0;

  @override
  List<_i3.ProductKeys> get items => [..._items];

  @override
  bool get hasMore => _items.length < _totalItems;

  Future<void> _fetch() async {
    final result = await _i3.ProductKeys.page(
      offset: _items.isEmpty ? 0 : null,
      last: _items.isEmpty ? null : _items.last,
    );
    _totalItems = result.success.$1;
    _items.addAll(result.success.$2);
    notifyListeners();
  }

  Future<void> fetchMore() async {
    await _fetch();
  }

  Future<void> build() async {
    await _fetch();
    final realtimeSubscriptions =
        await _i4.di.getAsync<_i5.RealtimeSubscriptions>();
    realtimeSubscriptions.subscribe(
      'databases.internal.collections.productKeys.documents',
      (message) {
        final event = message.events.first.split('.').last;
        switch (event) {
          case 'create':
            _items.add(_i3.ProductKeys.fromAppwrite(
                _i6.Document.fromMap(message.payload)));
            _totalItems++;
          case 'update':
            final newItem = _i3.ProductKeys.fromAppwrite(
                _i6.Document.fromMap(message.payload));
            final index = _items
                .indexWhere((_i3.ProductKeys item) => item.$id == newItem.$id);
            index != -1 ? _items[index] = newItem : null;
          case 'delete':
            final deletedItem = _i3.ProductKeys.fromAppwrite(
                _i6.Document.fromMap(message.payload));
            _items.removeWhere(
                (_i3.ProductKeys item) => item.$id == deletedItem.$id);
            _totalItems--;
        }
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _i4.di<_i5.RealtimeSubscriptions>().unsubscribe(
          'databases.internal.collections.productKeys.documents',
          (message) {},
        );
    super.dispose();
  }
}

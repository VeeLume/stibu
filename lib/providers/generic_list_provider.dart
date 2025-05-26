// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/foundation.dart' as _i1;

mixin GenericListProvider<T> on _i1.ChangeNotifier {
  List<T> get items;
  bool get hasMore;
}

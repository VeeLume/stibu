// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/foundation.dart' as _i1;

abstract class AuthProvider extends _i1.ChangeNotifier {
  bool get isAuthenticated;
  Future<void> build();
}

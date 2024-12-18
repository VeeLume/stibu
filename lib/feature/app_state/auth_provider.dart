import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:result_type/result_type.dart';
import 'package:stibu/appwrite.models.dart';
import 'package:stibu/main.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    final appwrite = getIt<AppwriteClient>();

    unawaited(
      appwrite.account.get().then((account) {
        log.info('Got account: ${account.name}');
        _isAuthenticated = true;
        notifyListeners();
      }).catchError((e) {
        log.warning('Failed to get account: $e');
      }),
    );
  }

  Future<Result<bool, String>> login(String email, String password) async {
    final appwrite = getIt<AppwriteClient>();
    try {
      await appwrite.account
          .createEmailPasswordSession(email: email, password: password);
      _isAuthenticated = true;
      notifyListeners();
      return Success(true);
    } on AppwriteException catch (e) {
      return Failure(e.message ?? 'Failed to login');
    }
  }

  Future<Result<bool, String>> logout() async {
    final appwrite = getIt<AppwriteClient>();
    try {
      await appwrite.account.deleteSession(sessionId: 'current');
      _isAuthenticated = false;
      notifyListeners();
      return Success(true);
    } on AppwriteException catch (e) {
      return Failure(e.message ?? 'Failed to logout');
    }
  }

  Future<Result<bool, String>> createAccount(
    String email,
    String password,
    String name,
  ) async {
    final appwrite = getIt<AppwriteClient>();
    try {
      await appwrite.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return Success(true);
    } on AppwriteException catch (e) {
      return Failure(e.message ?? 'Failed to create account');
    }
  }
}

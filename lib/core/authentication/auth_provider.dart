import 'package:appwrite/appwrite.dart';
import 'package:result_type/result_type.dart';
import 'package:stibu/main.dart';
import 'package:stibu/models/appwrite_client.dart';
import 'package:stibu/providers/auth_provider.dart';
import 'package:watch_it/watch_it.dart';

class AppAuthProvider extends AuthProvider {
  bool _isAuthenticated = false;
  @override
  bool get isAuthenticated => _isAuthenticated;

  Future<Result<void, AppwriteException>> login(
    String email,
    String password,
  ) async {
    try {
      await di<AppwriteClient>().account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      _isAuthenticated = true;
      notifyListeners();
      return Success(null);
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<void, AppwriteException>> logout() async {
    try {
      await di<AppwriteClient>().account.deleteSession(sessionId: 'current');
      _isAuthenticated = false;
      notifyListeners();
      return Success(null);
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<void, AppwriteException>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await di<AppwriteClient>().account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return Success(null);
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<void> build() async {
    try {
      await di<AppwriteClient>().account.get();
      log.d('User is authenticated');
      _isAuthenticated = true;
      notifyListeners();
    } on AppwriteException catch (e) {
      log.w('User is not authenticated: $e');
      _isAuthenticated = false;
      notifyListeners();
    }
  }
}

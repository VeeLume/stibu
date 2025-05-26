// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:stibu/models/collections.dart' as _i1;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' hide Locale;
import 'package:result_type/result_type.dart';
import 'package:stibu/models/base.dart';

class AppwriteClient {
  AppwriteClient(this.client)
      : account = Account(client),
        databases = Databases(client),
        realtime = Realtime(client),
        functions = Functions(client),
        avatars = Avatars(client),
        storage = Storage(client),
        locale = Locale(client);

  final Client client;

  final Account account;

  final Databases databases;

  final Realtime realtime;

  final Functions functions;

  final Avatars avatars;

  final Storage storage;

  final Locale locale;

  Future<Result<(int, List<T>), AppwriteException>>
      page<T extends AppwriteModel<T>>({
    required String databaseId,
    required String collectionId,
    required T Function(Document doc) fromAppwrite,
    int limit = 25,
    int? offset,
    T? last,
    List<String>? queries,
  }) async {
    assert(limit > 0, 'Limit must be greater than 0');
    assert(offset != null && offset >= 0 || last != null,
        'Either offset or last must be provided');
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.limit(limit),
          if (offset != null) Query.offset(offset),
          if (last != null) Query.cursorAfter(last.$id),
          ...?queries,
        ],
      );
      return Success((
        response.total,
        response.documents.map((e) => fromAppwrite(e)).toList(),
      ));
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<(int, List<T>), AppwriteException>>
      list<T extends AppwriteModel<T>>({
    required String databaseId,
    required String collectionId,
    required T Function(Document doc) fromAppwrite,
    List<String>? queries,
  }) async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: queries ?? [],
      );
      return Success((
        response.total,
        response.documents.map((e) => fromAppwrite(e)).toList(),
      ));
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<T, AppwriteException>> get<T extends AppwriteModel<T>>({
    required String databaseId,
    required String collectionId,
    required String documentId,
    required T Function(Document doc) fromAppwrite,
    List<String>? queries,
  }) async {
    try {
      final response = await databases.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        queries: queries,
      );
      return Success(fromAppwrite(response));
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<T, AppwriteException>> create<T extends AppwriteModel<T>>({
    required String databaseId,
    required String collectionId,
    required T Function(Document doc) fromAppwrite,
    required T model,
    _i1.RelationContext? context,
    List<String>? permissions,
  }) async {
    try {
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: model.$id,
        data: model.toAppwrite(context: context, includeId: false),
        permissions: permissions,
      );
      return Success(fromAppwrite(response));
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<T, AppwriteException>> update<T extends AppwriteModel<T>>({
    required String databaseId,
    required String collectionId,
    required T Function(Document doc) fromAppwrite,
    required T model,
    _i1.RelationContext? context,
    List<String>? permissions,
  }) async {
    try {
      final response = await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: model.$id,
        data: model.toAppwrite(context: context),
        permissions: permissions,
      );
      return Success(fromAppwrite(response));
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<void, AppwriteException>> delete({
    required String databaseId,
    required String collectionId,
    required String documentId,
  }) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
      return Success(null);
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }
}

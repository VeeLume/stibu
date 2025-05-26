// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i1;
import 'package:stibu/models/appwrite_client.dart' as _i2;
import 'package:get_it/get_it.dart' as _i3;
import 'package:flutter/foundation.dart' as _i4;
import 'package:stibu/models/base.dart' as _i5;
import 'package:appwrite/appwrite.dart' as _i6;
import 'package:appwrite/models.dart' as _i7;
import 'package:stibu/models/collections.dart' as _i8;
import 'package:result_type/result_type.dart' as _i9;

final _eq = const _i1.ListEquality().equals;
final _hash = const _i1.ListEquality().hash;
final _i2.AppwriteClient _client = _i3.GetIt.I<_i2.AppwriteClient>();

@_i4.immutable
class ProductKeys extends _i5.AppwriteModel<ProductKeys> {
  const ProductKeys._({
    required this.productKey,
    this.userId,
    required this.isValid,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  });

  factory ProductKeys({
    required String productKey,
    String? userId,
    required bool isValid,
  }) =>
      ProductKeys._(
        productKey: productKey,
        userId: userId,
        isValid: isValid,
        $id: _i6.ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory ProductKeys.fromAppwrite(_i7.Document doc) => ProductKeys._(
        productKey: doc.data['productKey'],
        userId: doc.data['userId'],
        isValid: doc.data['isValid'],
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const _i8.CollectionInfo collectionInfo = _i8.CollectionInfo(
    $id: 'productKeys',
    $permissions: [],
    databaseId: 'internal',
    name: 'ProductKeys',
    enabled: true,
    documentSecurity: false,
  );

  final String productKey;

  final String? userId;

  final bool isValid;

  @override
  Map<String, dynamic> toJson() => {
        'productKey': productKey,
        'userId': userId,
        'isValid': isValid,
      };

  @override
  ProductKeys copyWith({
    String Function()? productKey,
    String? Function()? userId,
    bool Function()? isValid,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      ProductKeys._(
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        productKey: productKey != null ? productKey() : this.productKey,
        userId: userId != null ? userId() : this.userId,
        isValid: isValid != null ? isValid() : this.isValid,
      );

  @override
  Map<String, dynamic> toAppwrite({
    _i8.RelationContext? context,
    bool includeId = true,
  }) {
    final Map<String, dynamic> data = {};
    if (includeId && (context?.includeId ?? true)) data['\$id'] = $id;
    if (context?.includeData ?? true) {
      data['productKey'] = productKey;
      data['userId'] = userId;
      data['isValid'] = isValid;
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductKeys) return false;
    return productKey == other.productKey &&
        userId == other.userId &&
        isValid == other.isValid;
  }

  @override
  int get hashCode => _hash([
        $id,
        productKey,
        userId,
        isValid,
      ]);

  static Future<_i9.Result<(int, List<ProductKeys>), _i6.AppwriteException>>
      page({
    int limit = 25,
    int? offset,
    ProductKeys? last,
    List<String>? queries,
  }) async =>
          _client.page<ProductKeys>(
            databaseId: collectionInfo.databaseId,
            collectionId: collectionInfo.$id,
            fromAppwrite: ProductKeys.fromAppwrite,
            limit: limit,
            offset: offset,
            last: last,
            queries: queries,
          );

  Future<_i9.Result<(int, List<ProductKeys>), _i6.AppwriteException>> list(
          [List<String>? queries]) async =>
      _client.list<ProductKeys>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: ProductKeys.fromAppwrite,
        queries: queries,
      );

  static Future<_i9.Result<ProductKeys, _i6.AppwriteException>> get(
    String documentId, {
    List<String>? queries,
  }) async =>
      _client.get<ProductKeys>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: ProductKeys.fromAppwrite,
        documentId: documentId,
        queries: queries,
      );

  Future<_i9.Result<ProductKeys, _i6.AppwriteException>> create(
          {_i8.RelationContext? context}) async =>
      _client.create<ProductKeys>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: ProductKeys.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i9.Result<ProductKeys, _i6.AppwriteException>> update(
          {_i8.RelationContext? context}) async =>
      _client.update<ProductKeys>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: ProductKeys.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i9.Result<void, _i6.AppwriteException>> delete() async =>
      _client.delete(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        documentId: $id,
      );
}

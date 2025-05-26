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
class CustomProducts extends _i5.AppwriteModel<CustomProducts> {
  const CustomProducts._({
    required this.id,
    required this.title,
    required this.price,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  });

  factory CustomProducts({
    required int id,
    required String title,
    required int price,
  }) =>
      CustomProducts._(
        id: id,
        title: title,
        price: price,
        $id: _i6.ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory CustomProducts.fromAppwrite(_i7.Document doc) => CustomProducts._(
        id: doc.data['id'],
        title: doc.data['title'],
        price: doc.data['price'],
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const _i8.CollectionInfo collectionInfo = _i8.CollectionInfo(
    $id: '67634d8600001ca71de4',
    $permissions: [],
    databaseId: '672bcb590033b5b2780a',
    name: 'CustomProducts',
    enabled: true,
    documentSecurity: false,
  );

  final int id;

  final String title;

  final int price;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
      };

  @override
  CustomProducts copyWith({
    int Function()? id,
    String Function()? title,
    int Function()? price,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      CustomProducts._(
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        id: id != null ? id() : this.id,
        title: title != null ? title() : this.title,
        price: price != null ? price() : this.price,
      );

  @override
  Map<String, dynamic> toAppwrite({
    _i8.RelationContext? context,
    bool includeId = true,
  }) {
    final Map<String, dynamic> data = {};
    if (includeId && (context?.includeId ?? true)) data['\$id'] = $id;
    if (context?.includeData ?? true) {
      data['id'] = id;
      data['title'] = title;
      data['price'] = price;
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CustomProducts) return false;
    return id == other.id && title == other.title && price == other.price;
  }

  @override
  int get hashCode => _hash([
        $id,
        id,
        title,
        price,
      ]);

  static Future<_i9.Result<(int, List<CustomProducts>), _i6.AppwriteException>>
      page({
    int limit = 25,
    int? offset,
    CustomProducts? last,
    List<String>? queries,
  }) async =>
          _client.page<CustomProducts>(
            databaseId: collectionInfo.databaseId,
            collectionId: collectionInfo.$id,
            fromAppwrite: CustomProducts.fromAppwrite,
            limit: limit,
            offset: offset,
            last: last,
            queries: queries,
          );

  Future<_i9.Result<(int, List<CustomProducts>), _i6.AppwriteException>> list(
          [List<String>? queries]) async =>
      _client.list<CustomProducts>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: CustomProducts.fromAppwrite,
        queries: queries,
      );

  static Future<_i9.Result<CustomProducts, _i6.AppwriteException>> get(
    String documentId, {
    List<String>? queries,
  }) async =>
      _client.get<CustomProducts>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: CustomProducts.fromAppwrite,
        documentId: documentId,
        queries: queries,
      );

  Future<_i9.Result<CustomProducts, _i6.AppwriteException>> create(
          {_i8.RelationContext? context}) async =>
      _client.create<CustomProducts>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: CustomProducts.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i9.Result<CustomProducts, _i6.AppwriteException>> update(
          {_i8.RelationContext? context}) async =>
      _client.update<CustomProducts>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: CustomProducts.fromAppwrite,
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

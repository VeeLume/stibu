// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i1;
import 'package:stibu/models/appwrite_client.dart' as _i2;
import 'package:get_it/get_it.dart' as _i3;
import 'package:flutter/foundation.dart' as _i4;
import 'package:stibu/models/base.dart' as _i5;
import 'package:stibu/models/orders.dart' as _i6;
import 'package:appwrite/appwrite.dart' as _i7;
import 'package:appwrite/models.dart' as _i8;
import 'package:stibu/models/collections.dart' as _i9;
import 'package:result_type/result_type.dart' as _i10;

final _eq = const _i1.ListEquality().equals;
final _hash = const _i1.ListEquality().hash;
final _i2.AppwriteClient _client = _i3.GetIt.I<_i2.AppwriteClient>();

@_i4.immutable
class OrderProducts extends _i5.AppwriteModel<OrderProducts> {
  const OrderProducts._({
    this.order,
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  });

  factory OrderProducts({
    _i6.Orders? order,
    required int id,
    required String title,
    required int price,
    required int quantity,
  }) =>
      OrderProducts._(
        order: order,
        id: id,
        title: title,
        price: price,
        quantity: quantity,
        $id: _i7.ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory OrderProducts.fromAppwrite(_i8.Document doc) => OrderProducts._(
        order: doc.data['order'] != null
            ? _i6.Orders.fromAppwrite(_i8.Document.fromMap(doc.data['order']))
            : null,
        id: doc.data['id'],
        title: doc.data['title'],
        price: doc.data['price'],
        quantity: doc.data['quantity'],
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const _i9.CollectionInfo collectionInfo = _i9.CollectionInfo(
    $id: '672bcd4b002428afc3cb',
    $permissions: ['create("label:validProductKey")'],
    databaseId: '672bcb590033b5b2780a',
    name: 'OrderProducts',
    enabled: true,
    documentSecurity: true,
  );

  final _i6.Orders? order;

  static const _i9.Relation orderRelation = _i9.Relation(
    required: false,
    array: false,
    relatedCollection: '672bcca5001880d288b0',
    relationType: _i9.RelationType.oneToMany,
    twoWay: true,
    twoWayKey: 'products',
    onDelete: _i9.RelationOnDelete.cascade,
    side: _i9.RelationSide.child,
  );

  final int id;

  final String title;

  final int price;

  final int quantity;

  @override
  Map<String, dynamic> toJson() => {
        'order': order?.toJson(),
        'id': id,
        'title': title,
        'price': price,
        'quantity': quantity,
      };

  @override
  OrderProducts copyWith({
    _i6.Orders? Function()? order,
    int Function()? id,
    String Function()? title,
    int Function()? price,
    int Function()? quantity,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      OrderProducts._(
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        order: order != null ? order() : this.order,
        id: id != null ? id() : this.id,
        title: title != null ? title() : this.title,
        price: price != null ? price() : this.price,
        quantity: quantity != null ? quantity() : this.quantity,
      );

  @override
  Map<String, dynamic> toAppwrite({
    _i9.RelationContext? context,
    bool includeId = true,
  }) {
    final Map<String, dynamic> data = {};
    if (includeId && (context?.includeId ?? true)) data['\$id'] = $id;
    if (context?.includeData ?? true) {
      data['id'] = id;
      data['title'] = title;
      data['price'] = price;
      data['quantity'] = quantity;
    }
    if (context?['order'] != null) {
      data['order'] = order?.toAppwrite(context: context?['order']);
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderProducts) return false;
    return order == other.order &&
        id == other.id &&
        title == other.title &&
        price == other.price &&
        quantity == other.quantity;
  }

  @override
  int get hashCode => _hash([
        $id,
        order,
        id,
        title,
        price,
        quantity,
      ]);

  static Future<_i10.Result<(int, List<OrderProducts>), _i7.AppwriteException>>
      page({
    int limit = 25,
    int? offset,
    OrderProducts? last,
    List<String>? queries,
  }) async =>
          _client.page<OrderProducts>(
            databaseId: collectionInfo.databaseId,
            collectionId: collectionInfo.$id,
            fromAppwrite: OrderProducts.fromAppwrite,
            limit: limit,
            offset: offset,
            last: last,
            queries: queries,
          );

  Future<_i10.Result<(int, List<OrderProducts>), _i7.AppwriteException>> list(
          [List<String>? queries]) async =>
      _client.list<OrderProducts>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: OrderProducts.fromAppwrite,
        queries: queries,
      );

  static Future<_i10.Result<OrderProducts, _i7.AppwriteException>> get(
    String documentId, {
    List<String>? queries,
  }) async =>
      _client.get<OrderProducts>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: OrderProducts.fromAppwrite,
        documentId: documentId,
        queries: queries,
      );

  Future<_i10.Result<OrderProducts, _i7.AppwriteException>> create(
          {_i9.RelationContext? context}) async =>
      _client.create<OrderProducts>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: OrderProducts.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i10.Result<OrderProducts, _i7.AppwriteException>> update(
          {_i9.RelationContext? context}) async =>
      _client.update<OrderProducts>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: OrderProducts.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i10.Result<void, _i7.AppwriteException>> delete() async =>
      _client.delete(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        documentId: $id,
      );
}

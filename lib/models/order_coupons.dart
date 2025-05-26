// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i1;
import 'package:stibu/models/appwrite_client.dart' as _i2;
import 'package:get_it/get_it.dart' as _i3;
import 'package:flutter/foundation.dart' as _i4;
import 'package:stibu/models/base.dart' as _i5;
import 'package:stibu/models/orders.dart' as _i6;
import 'package:stibu/models/coupons.dart' as _i7;
import 'package:appwrite/appwrite.dart' as _i8;
import 'package:appwrite/models.dart' as _i9;
import 'package:stibu/models/collections.dart' as _i10;
import 'package:result_type/result_type.dart' as _i11;

final _eq = const _i1.ListEquality().equals;
final _hash = const _i1.ListEquality().hash;
final _i2.AppwriteClient _client = _i3.GetIt.I<_i2.AppwriteClient>();

@_i4.immutable
class OrderCoupons extends _i5.AppwriteModel<OrderCoupons> {
  const OrderCoupons._({
    this.order,
    required this.name,
    required this.amount,
    this.coupons,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  });

  factory OrderCoupons({
    _i6.Orders? order,
    required String name,
    required int amount,
    _i7.Coupons? coupons,
  }) =>
      OrderCoupons._(
        order: order,
        name: name,
        amount: amount,
        coupons: coupons,
        $id: _i8.ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory OrderCoupons.fromAppwrite(_i9.Document doc) => OrderCoupons._(
        order: doc.data['order'] != null
            ? _i6.Orders.fromAppwrite(_i9.Document.fromMap(doc.data['order']))
            : null,
        name: doc.data['name'],
        amount: doc.data['amount'],
        coupons: doc.data['coupons'] != null
            ? _i7.Coupons.fromAppwrite(
                _i9.Document.fromMap(doc.data['coupons']))
            : null,
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const _i10.CollectionInfo collectionInfo = _i10.CollectionInfo(
    $id: '672bcf00000075632fd4',
    $permissions: ['create("label:validProductKey")'],
    databaseId: '672bcb590033b5b2780a',
    name: 'OrderCoupons',
    enabled: true,
    documentSecurity: true,
  );

  final _i6.Orders? order;

  static const _i10.Relation orderRelation = _i10.Relation(
    required: false,
    array: false,
    relatedCollection: '672bcca5001880d288b0',
    relationType: _i10.RelationType.oneToMany,
    twoWay: true,
    twoWayKey: 'coupons',
    onDelete: _i10.RelationOnDelete.cascade,
    side: _i10.RelationSide.child,
  );

  final String name;

  final int amount;

  final _i7.Coupons? coupons;

  static const _i10.Relation couponsRelation = _i10.Relation(
    required: false,
    array: false,
    relatedCollection: '6804dc0d0032aa687528',
    relationType: _i10.RelationType.manyToOne,
    twoWay: true,
    twoWayKey: 'orderCoupons',
    onDelete: _i10.RelationOnDelete.setNull,
    side: _i10.RelationSide.parent,
  );

  @override
  Map<String, dynamic> toJson() => {
        'order': order?.toJson(),
        'name': name,
        'amount': amount,
        'coupons': coupons?.toJson(),
      };

  @override
  OrderCoupons copyWith({
    _i6.Orders? Function()? order,
    String Function()? name,
    int Function()? amount,
    _i7.Coupons? Function()? coupons,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      OrderCoupons._(
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        order: order != null ? order() : this.order,
        name: name != null ? name() : this.name,
        amount: amount != null ? amount() : this.amount,
        coupons: coupons != null ? coupons() : this.coupons,
      );

  @override
  Map<String, dynamic> toAppwrite({
    _i10.RelationContext? context,
    bool includeId = true,
  }) {
    final Map<String, dynamic> data = {};
    if (includeId && (context?.includeId ?? true)) data['\$id'] = $id;
    if (context?.includeData ?? true) {
      data['name'] = name;
      data['amount'] = amount;
    }
    if (context?['order'] != null) {
      data['order'] = order?.toAppwrite(context: context?['order']);
    }
    if (context?['coupons'] != null) {
      data['coupons'] = coupons?.toAppwrite(context: context?['coupons']);
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderCoupons) return false;
    return order == other.order &&
        name == other.name &&
        amount == other.amount &&
        coupons == other.coupons;
  }

  @override
  int get hashCode => _hash([
        $id,
        order,
        name,
        amount,
        coupons,
      ]);

  static Future<_i11.Result<(int, List<OrderCoupons>), _i8.AppwriteException>>
      page({
    int limit = 25,
    int? offset,
    OrderCoupons? last,
    List<String>? queries,
  }) async =>
          _client.page<OrderCoupons>(
            databaseId: collectionInfo.databaseId,
            collectionId: collectionInfo.$id,
            fromAppwrite: OrderCoupons.fromAppwrite,
            limit: limit,
            offset: offset,
            last: last,
            queries: queries,
          );

  Future<_i11.Result<(int, List<OrderCoupons>), _i8.AppwriteException>> list(
          [List<String>? queries]) async =>
      _client.list<OrderCoupons>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: OrderCoupons.fromAppwrite,
        queries: queries,
      );

  static Future<_i11.Result<OrderCoupons, _i8.AppwriteException>> get(
    String documentId, {
    List<String>? queries,
  }) async =>
      _client.get<OrderCoupons>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: OrderCoupons.fromAppwrite,
        documentId: documentId,
        queries: queries,
      );

  Future<_i11.Result<OrderCoupons, _i8.AppwriteException>> create(
          {_i10.RelationContext? context}) async =>
      _client.create<OrderCoupons>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: OrderCoupons.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i11.Result<OrderCoupons, _i8.AppwriteException>> update(
          {_i10.RelationContext? context}) async =>
      _client.update<OrderCoupons>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: OrderCoupons.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i11.Result<void, _i8.AppwriteException>> delete() async =>
      _client.delete(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        documentId: $id,
      );
}

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i1;
import 'package:stibu/models/appwrite_client.dart' as _i2;
import 'package:get_it/get_it.dart' as _i3;
import 'package:flutter/foundation.dart' as _i4;
import 'package:stibu/models/base.dart' as _i5;
import 'package:stibu/models/order_coupons.dart' as _i6;
import 'package:appwrite/appwrite.dart' as _i7;
import 'package:appwrite/models.dart' as _i8;
import 'package:stibu/models/collections.dart' as _i9;
import 'package:result_type/result_type.dart' as _i10;

final _eq = const _i1.ListEquality().equals;
final _hash = const _i1.ListEquality().hash;
final _i2.AppwriteClient _client = _i3.GetIt.I<_i2.AppwriteClient>();

@_i4.immutable
class Coupons extends _i5.AppwriteModel<Coupons> {
  const Coupons._({
    required this.orderCoupons,
    required this.code,
    required this.creationDate,
    this.lastChangeDate,
    required this.initialValue,
    required this.remainingValue,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  });

  factory Coupons({
    List<_i6.OrderCoupons> orderCoupons = const [],
    required String code,
    required DateTime creationDate,
    DateTime? lastChangeDate,
    required int initialValue,
    required int remainingValue,
  }) =>
      Coupons._(
        orderCoupons: orderCoupons,
        code: code,
        creationDate: creationDate,
        lastChangeDate: lastChangeDate,
        initialValue: initialValue,
        remainingValue: remainingValue,
        $id: _i7.ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory Coupons.fromAppwrite(_i8.Document doc) => Coupons._(
        orderCoupons: List.unmodifiable(doc.data['orderCoupons']?.map((e) =>
                _i6.OrderCoupons.fromAppwrite(_i8.Document.fromMap(e))) ??
            []),
        code: doc.data['code'],
        creationDate: DateTime.parse(doc.data['creationDate']),
        lastChangeDate: doc.data['lastChangeDate'] != null
            ? DateTime.parse(doc.data['lastChangeDate'])
            : null,
        initialValue: doc.data['initialValue'],
        remainingValue: doc.data['remainingValue'],
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const _i9.CollectionInfo collectionInfo = _i9.CollectionInfo(
    $id: '6804dc0d0032aa687528',
    $permissions: ['create("label:validProductKey")'],
    databaseId: '672bcb590033b5b2780a',
    name: 'Coupons',
    enabled: true,
    documentSecurity: true,
  );

  final List<_i6.OrderCoupons> orderCoupons;

  static const _i9.Relation orderCouponsRelation = _i9.Relation(
    required: false,
    array: true,
    relatedCollection: '672bcf00000075632fd4',
    relationType: _i9.RelationType.manyToOne,
    twoWay: true,
    twoWayKey: 'coupons',
    onDelete: _i9.RelationOnDelete.setNull,
    side: _i9.RelationSide.child,
  );

  final String code;

  final DateTime creationDate;

  final DateTime? lastChangeDate;

  final int initialValue;

  final int remainingValue;

  @override
  Map<String, dynamic> toJson() => {
        'orderCoupons': orderCoupons.map((e) => e.toJson()).toList(),
        'code': code,
        'creationDate': creationDate.toIso8601String(),
        'lastChangeDate': lastChangeDate?.toIso8601String(),
        'initialValue': initialValue,
        'remainingValue': remainingValue,
      };

  @override
  Coupons copyWith({
    List<_i6.OrderCoupons> Function()? orderCoupons,
    String Function()? code,
    DateTime Function()? creationDate,
    DateTime? Function()? lastChangeDate,
    int Function()? initialValue,
    int Function()? remainingValue,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      Coupons._(
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        orderCoupons: orderCoupons != null ? orderCoupons() : this.orderCoupons,
        code: code != null ? code() : this.code,
        creationDate: creationDate != null ? creationDate() : this.creationDate,
        lastChangeDate:
            lastChangeDate != null ? lastChangeDate() : this.lastChangeDate,
        initialValue: initialValue != null ? initialValue() : this.initialValue,
        remainingValue:
            remainingValue != null ? remainingValue() : this.remainingValue,
      );

  @override
  Map<String, dynamic> toAppwrite({
    _i9.RelationContext? context,
    bool includeId = true,
  }) {
    final Map<String, dynamic> data = {};
    if (includeId && (context?.includeId ?? true)) data['\$id'] = $id;
    if (context?.includeData ?? true) {
      data['code'] = code;
      data['creationDate'] = creationDate.toIso8601String();
      data['lastChangeDate'] = lastChangeDate?.toIso8601String();
      data['initialValue'] = initialValue;
      data['remainingValue'] = remainingValue;
    }
    if (context?['orderCoupons'] != null) {
      data['orderCoupons'] = orderCoupons
          .map((e) => e.toAppwrite(context: context?['orderCoupons']))
          .toList();
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Coupons) return false;
    return _eq(orderCoupons, other.orderCoupons) &&
        code == other.code &&
        creationDate == other.creationDate &&
        lastChangeDate == other.lastChangeDate &&
        initialValue == other.initialValue &&
        remainingValue == other.remainingValue;
  }

  @override
  int get hashCode => _hash([
        $id,
        ...(orderCoupons),
        code,
        creationDate,
        lastChangeDate,
        initialValue,
        remainingValue,
      ]);

  static Future<_i10.Result<(int, List<Coupons>), _i7.AppwriteException>> page({
    int limit = 25,
    int? offset,
    Coupons? last,
    List<String>? queries,
  }) async =>
      _client.page<Coupons>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Coupons.fromAppwrite,
        limit: limit,
        offset: offset,
        last: last,
        queries: queries,
      );

  Future<_i10.Result<(int, List<Coupons>), _i7.AppwriteException>> list(
          [List<String>? queries]) async =>
      _client.list<Coupons>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Coupons.fromAppwrite,
        queries: queries,
      );

  static Future<_i10.Result<Coupons, _i7.AppwriteException>> get(
    String documentId, {
    List<String>? queries,
  }) async =>
      _client.get<Coupons>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Coupons.fromAppwrite,
        documentId: documentId,
        queries: queries,
      );

  Future<_i10.Result<Coupons, _i7.AppwriteException>> create(
          {_i9.RelationContext? context}) async =>
      _client.create<Coupons>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Coupons.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i10.Result<Coupons, _i7.AppwriteException>> update(
          {_i9.RelationContext? context}) async =>
      _client.update<Coupons>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Coupons.fromAppwrite,
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

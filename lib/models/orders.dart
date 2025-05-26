// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i1;
import 'package:stibu/models/appwrite_client.dart' as _i2;
import 'package:get_it/get_it.dart' as _i3;
import 'package:flutter/foundation.dart' as _i4;
import 'package:stibu/models/base.dart' as _i5;
import 'package:stibu/models/invoices.dart' as _i6;
import 'package:stibu/models/order_products.dart' as _i7;
import 'package:stibu/models/order_coupons.dart' as _i8;
import 'package:appwrite/appwrite.dart' as _i9;
import 'package:appwrite/models.dart' as _i10;
import 'package:stibu/models/collections.dart' as _i11;
import 'package:result_type/result_type.dart' as _i12;

final _eq = const _i1.ListEquality().equals;
final _hash = const _i1.ListEquality().hash;
final _i2.AppwriteClient _client = _i3.GetIt.I<_i2.AppwriteClient>();

@_i4.immutable
class Orders extends _i5.AppwriteModel<Orders> {
  const Orders._({
    required this.date,
    required this.customerId,
    required this.customerName,
    this.street,
    this.zip,
    this.city,
    this.invoice,
    required this.products,
    required this.coupons,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  });

  factory Orders({
    required DateTime date,
    required int customerId,
    required String customerName,
    String? street,
    String? zip,
    String? city,
    _i6.Invoices? invoice,
    List<_i7.OrderProducts> products = const [],
    List<_i8.OrderCoupons> coupons = const [],
  }) =>
      Orders._(
        date: date,
        customerId: customerId,
        customerName: customerName,
        street: street,
        zip: zip,
        city: city,
        invoice: invoice,
        products: products,
        coupons: coupons,
        $id: _i9.ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory Orders.fromAppwrite(_i10.Document doc) => Orders._(
        date: DateTime.parse(doc.data['date']),
        customerId: doc.data['customerId'],
        customerName: doc.data['customerName'],
        street: doc.data['street'],
        zip: doc.data['zip'],
        city: doc.data['city'],
        invoice: doc.data['invoice'] != null
            ? _i6.Invoices.fromAppwrite(
                _i10.Document.fromMap(doc.data['invoice']))
            : null,
        products: List.unmodifiable(doc.data['products']?.map((e) =>
                _i7.OrderProducts.fromAppwrite(_i10.Document.fromMap(e))) ??
            []),
        coupons: List.unmodifiable(doc.data['coupons']?.map((e) =>
                _i8.OrderCoupons.fromAppwrite(_i10.Document.fromMap(e))) ??
            []),
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const _i11.CollectionInfo collectionInfo = _i11.CollectionInfo(
    $id: '672bcca5001880d288b0',
    $permissions: ['create("label:validProductKey")'],
    databaseId: '672bcb590033b5b2780a',
    name: 'Orders',
    enabled: true,
    documentSecurity: true,
  );

  final DateTime date;

  final int customerId;

  final String customerName;

  final String? street;

  final String? zip;

  final String? city;

  final _i6.Invoices? invoice;

  static const _i11.Relation invoiceRelation = _i11.Relation(
    required: false,
    array: false,
    relatedCollection: '672bcbe40035299f5750',
    relationType: _i11.RelationType.oneToOne,
    twoWay: true,
    twoWayKey: 'order',
    onDelete: _i11.RelationOnDelete.restrict,
    side: _i11.RelationSide.parent,
  );

  final List<_i7.OrderProducts> products;

  static const _i11.Relation productsRelation = _i11.Relation(
    required: false,
    array: true,
    relatedCollection: '672bcd4b002428afc3cb',
    relationType: _i11.RelationType.oneToMany,
    twoWay: true,
    twoWayKey: 'order',
    onDelete: _i11.RelationOnDelete.cascade,
    side: _i11.RelationSide.parent,
  );

  final List<_i8.OrderCoupons> coupons;

  static const _i11.Relation couponsRelation = _i11.Relation(
    required: false,
    array: true,
    relatedCollection: '672bcf00000075632fd4',
    relationType: _i11.RelationType.oneToMany,
    twoWay: true,
    twoWayKey: 'order',
    onDelete: _i11.RelationOnDelete.cascade,
    side: _i11.RelationSide.parent,
  );

  @override
  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'customerId': customerId,
        'customerName': customerName,
        'street': street,
        'zip': zip,
        'city': city,
        'invoice': invoice?.toJson(),
        'products': products.map((e) => e.toJson()).toList(),
        'coupons': coupons.map((e) => e.toJson()).toList(),
      };

  @override
  Orders copyWith({
    DateTime Function()? date,
    int Function()? customerId,
    String Function()? customerName,
    String? Function()? street,
    String? Function()? zip,
    String? Function()? city,
    _i6.Invoices? Function()? invoice,
    List<_i7.OrderProducts> Function()? products,
    List<_i8.OrderCoupons> Function()? coupons,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      Orders._(
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        date: date != null ? date() : this.date,
        customerId: customerId != null ? customerId() : this.customerId,
        customerName: customerName != null ? customerName() : this.customerName,
        street: street != null ? street() : this.street,
        zip: zip != null ? zip() : this.zip,
        city: city != null ? city() : this.city,
        invoice: invoice != null ? invoice() : this.invoice,
        products: products != null ? products() : this.products,
        coupons: coupons != null ? coupons() : this.coupons,
      );

  @override
  Map<String, dynamic> toAppwrite({
    _i11.RelationContext? context,
    bool includeId = true,
  }) {
    final Map<String, dynamic> data = {};
    if (includeId && (context?.includeId ?? true)) data['\$id'] = $id;
    if (context?.includeData ?? true) {
      data['date'] = date.toIso8601String();
      data['customerId'] = customerId;
      data['customerName'] = customerName;
      data['street'] = street;
      data['zip'] = zip;
      data['city'] = city;
    }
    if (context?['invoice'] != null) {
      data['invoice'] = invoice?.toAppwrite(context: context?['invoice']);
    }
    if (context?['products'] != null) {
      data['products'] = products
          .map((e) => e.toAppwrite(context: context?['products']))
          .toList();
    }
    if (context?['coupons'] != null) {
      data['coupons'] = coupons
          .map((e) => e.toAppwrite(context: context?['coupons']))
          .toList();
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Orders) return false;
    return date == other.date &&
        customerId == other.customerId &&
        customerName == other.customerName &&
        street == other.street &&
        zip == other.zip &&
        city == other.city &&
        invoice == other.invoice &&
        _eq(products, other.products) &&
        _eq(coupons, other.coupons);
  }

  @override
  int get hashCode => _hash([
        $id,
        date,
        customerId,
        customerName,
        street,
        zip,
        city,
        invoice,
        ...(products),
        ...(coupons),
      ]);

  static Future<_i12.Result<(int, List<Orders>), _i9.AppwriteException>> page({
    int limit = 25,
    int? offset,
    Orders? last,
    List<String>? queries,
  }) async =>
      _client.page<Orders>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Orders.fromAppwrite,
        limit: limit,
        offset: offset,
        last: last,
        queries: queries,
      );

  Future<_i12.Result<(int, List<Orders>), _i9.AppwriteException>> list(
          [List<String>? queries]) async =>
      _client.list<Orders>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Orders.fromAppwrite,
        queries: queries,
      );

  static Future<_i12.Result<Orders, _i9.AppwriteException>> get(
    String documentId, {
    List<String>? queries,
  }) async =>
      _client.get<Orders>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Orders.fromAppwrite,
        documentId: documentId,
        queries: queries,
      );

  Future<_i12.Result<Orders, _i9.AppwriteException>> create(
          {_i11.RelationContext? context}) async =>
      _client.create<Orders>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Orders.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i12.Result<Orders, _i9.AppwriteException>> update(
          {_i11.RelationContext? context}) async =>
      _client.update<Orders>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Orders.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i12.Result<void, _i9.AppwriteException>> delete() async =>
      _client.delete(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        documentId: $id,
      );
}

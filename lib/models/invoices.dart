// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i1;
import 'package:stibu/models/appwrite_client.dart' as _i2;
import 'package:get_it/get_it.dart' as _i3;
import 'package:flutter/foundation.dart' as _i4;
import 'package:stibu/models/base.dart' as _i5;
import 'package:stibu/models/calendar_events.dart' as _i6;
import 'package:stibu/models/orders.dart' as _i7;
import 'package:appwrite/appwrite.dart' as _i8;
import 'package:appwrite/models.dart' as _i9;
import 'package:stibu/models/collections.dart' as _i10;
import 'package:result_type/result_type.dart' as _i11;

final _eq = const _i1.ListEquality().equals;
final _hash = const _i1.ListEquality().hash;
final _i2.AppwriteClient _client = _i3.GetIt.I<_i2.AppwriteClient>();

@_i4.immutable
class Invoices extends _i5.AppwriteModel<Invoices> {
  const Invoices._({
    this.calendarEvent,
    this.order,
    required this.date,
    required this.name,
    this.notes,
    required this.amount,
    required this.invoiceNumber,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  });

  factory Invoices({
    _i6.CalendarEvents? calendarEvent,
    _i7.Orders? order,
    required DateTime date,
    required String name,
    String? notes,
    required int amount,
    required String invoiceNumber,
  }) =>
      Invoices._(
        calendarEvent: calendarEvent,
        order: order,
        date: date,
        name: name,
        notes: notes,
        amount: amount,
        invoiceNumber: invoiceNumber,
        $id: _i8.ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory Invoices.fromAppwrite(_i9.Document doc) => Invoices._(
        calendarEvent: doc.data['calendarEvent'] != null
            ? _i6.CalendarEvents.fromAppwrite(
                _i9.Document.fromMap(doc.data['calendarEvent']))
            : null,
        order: doc.data['order'] != null
            ? _i7.Orders.fromAppwrite(_i9.Document.fromMap(doc.data['order']))
            : null,
        date: DateTime.parse(doc.data['date']),
        name: doc.data['name'],
        notes: doc.data['notes'],
        amount: doc.data['amount'],
        invoiceNumber: doc.data['invoiceNumber'],
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const _i10.CollectionInfo collectionInfo = _i10.CollectionInfo(
    $id: '672bcbe40035299f5750',
    $permissions: ['create("label:validProductKey")'],
    databaseId: '672bcb590033b5b2780a',
    name: 'Invoices',
    enabled: true,
    documentSecurity: true,
  );

  final _i6.CalendarEvents? calendarEvent;

  static const _i10.Relation calendarEventRelation = _i10.Relation(
    required: false,
    array: false,
    relatedCollection: '672bce09001905da8109',
    relationType: _i10.RelationType.oneToOne,
    twoWay: true,
    twoWayKey: 'invoice',
    onDelete: _i10.RelationOnDelete.restrict,
    side: _i10.RelationSide.child,
  );

  final _i7.Orders? order;

  static const _i10.Relation orderRelation = _i10.Relation(
    required: false,
    array: false,
    relatedCollection: '672bcca5001880d288b0',
    relationType: _i10.RelationType.oneToOne,
    twoWay: true,
    twoWayKey: 'invoice',
    onDelete: _i10.RelationOnDelete.restrict,
    side: _i10.RelationSide.child,
  );

  final DateTime date;

  final String name;

  final String? notes;

  final int amount;

  final String invoiceNumber;

  @override
  Map<String, dynamic> toJson() => {
        'calendarEvent': calendarEvent?.toJson(),
        'order': order?.toJson(),
        'date': date.toIso8601String(),
        'name': name,
        'notes': notes,
        'amount': amount,
        'invoiceNumber': invoiceNumber,
      };

  @override
  Invoices copyWith({
    _i6.CalendarEvents? Function()? calendarEvent,
    _i7.Orders? Function()? order,
    DateTime Function()? date,
    String Function()? name,
    String? Function()? notes,
    int Function()? amount,
    String Function()? invoiceNumber,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      Invoices._(
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        calendarEvent:
            calendarEvent != null ? calendarEvent() : this.calendarEvent,
        order: order != null ? order() : this.order,
        date: date != null ? date() : this.date,
        name: name != null ? name() : this.name,
        notes: notes != null ? notes() : this.notes,
        amount: amount != null ? amount() : this.amount,
        invoiceNumber:
            invoiceNumber != null ? invoiceNumber() : this.invoiceNumber,
      );

  @override
  Map<String, dynamic> toAppwrite({
    _i10.RelationContext? context,
    bool includeId = true,
  }) {
    final Map<String, dynamic> data = {};
    if (includeId && (context?.includeId ?? true)) data['\$id'] = $id;
    if (context?.includeData ?? true) {
      data['date'] = date.toIso8601String();
      data['name'] = name;
      data['notes'] = notes;
      data['amount'] = amount;
      data['invoiceNumber'] = invoiceNumber;
    }
    if (context?['calendarEvent'] != null) {
      data['calendarEvent'] =
          calendarEvent?.toAppwrite(context: context?['calendarEvent']);
    }
    if (context?['order'] != null) {
      data['order'] = order?.toAppwrite(context: context?['order']);
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Invoices) return false;
    return calendarEvent == other.calendarEvent &&
        order == other.order &&
        date == other.date &&
        name == other.name &&
        notes == other.notes &&
        amount == other.amount &&
        invoiceNumber == other.invoiceNumber;
  }

  @override
  int get hashCode => _hash([
        $id,
        calendarEvent,
        order,
        date,
        name,
        notes,
        amount,
        invoiceNumber,
      ]);

  static Future<_i11.Result<(int, List<Invoices>), _i8.AppwriteException>>
      page({
    int limit = 25,
    int? offset,
    Invoices? last,
    List<String>? queries,
  }) async =>
          _client.page<Invoices>(
            databaseId: collectionInfo.databaseId,
            collectionId: collectionInfo.$id,
            fromAppwrite: Invoices.fromAppwrite,
            limit: limit,
            offset: offset,
            last: last,
            queries: queries,
          );

  Future<_i11.Result<(int, List<Invoices>), _i8.AppwriteException>> list(
          [List<String>? queries]) async =>
      _client.list<Invoices>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Invoices.fromAppwrite,
        queries: queries,
      );

  static Future<_i11.Result<Invoices, _i8.AppwriteException>> get(
    String documentId, {
    List<String>? queries,
  }) async =>
      _client.get<Invoices>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Invoices.fromAppwrite,
        documentId: documentId,
        queries: queries,
      );

  Future<_i11.Result<Invoices, _i8.AppwriteException>> create(
          {_i10.RelationContext? context}) async =>
      _client.create<Invoices>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Invoices.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i11.Result<Invoices, _i8.AppwriteException>> update(
          {_i10.RelationContext? context}) async =>
      _client.update<Invoices>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Invoices.fromAppwrite,
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

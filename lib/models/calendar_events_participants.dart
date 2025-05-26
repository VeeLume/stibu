// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i1;
import 'package:stibu/models/appwrite_client.dart' as _i2;
import 'package:get_it/get_it.dart' as _i3;
import 'package:flutter/foundation.dart' as _i4;
import 'package:stibu/models/base.dart' as _i5;
import 'package:stibu/models/calendar_events.dart' as _i6;
import 'package:stibu/models/customers.dart' as _i7;
import 'package:appwrite/appwrite.dart' as _i8;
import 'package:appwrite/models.dart' as _i9;
import 'package:stibu/models/collections.dart' as _i10;
import 'package:result_type/result_type.dart' as _i11;

final _eq = const _i1.ListEquality().equals;
final _hash = const _i1.ListEquality().hash;
final _i2.AppwriteClient _client = _i3.GetIt.I<_i2.AppwriteClient>();

enum CalendarEventsParticipantsStatus { accepted, declined, pending }

@_i4.immutable
class CalendarEventsParticipants
    extends _i5.AppwriteModel<CalendarEventsParticipants> {
  const CalendarEventsParticipants._({
    this.event,
    required this.status,
    this.customer,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  });

  factory CalendarEventsParticipants({
    _i6.CalendarEvents? event,
    required CalendarEventsParticipantsStatus status,
    _i7.Customers? customer,
  }) =>
      CalendarEventsParticipants._(
        event: event,
        status: status,
        customer: customer,
        $id: _i8.ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory CalendarEventsParticipants.fromAppwrite(_i9.Document doc) =>
      CalendarEventsParticipants._(
        event: doc.data['event'] != null
            ? _i6.CalendarEvents.fromAppwrite(
                _i9.Document.fromMap(doc.data['event']))
            : null,
        status:
            CalendarEventsParticipantsStatus.values.byName(doc.data['status']),
        customer: doc.data['customer'] != null
            ? _i7.Customers.fromAppwrite(
                _i9.Document.fromMap(doc.data['customer']))
            : null,
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const _i10.CollectionInfo collectionInfo = _i10.CollectionInfo(
    $id: '672bcebb0002c448aa73',
    $permissions: ['create("label:validProductKey")'],
    databaseId: '672bcb590033b5b2780a',
    name: 'CalendarEventsParticipants',
    enabled: true,
    documentSecurity: true,
  );

  final _i6.CalendarEvents? event;

  static const _i10.Relation eventRelation = _i10.Relation(
    required: false,
    array: false,
    relatedCollection: '672bce09001905da8109',
    relationType: _i10.RelationType.oneToMany,
    twoWay: true,
    twoWayKey: 'participants',
    onDelete: _i10.RelationOnDelete.cascade,
    side: _i10.RelationSide.child,
  );

  final CalendarEventsParticipantsStatus status;

  final _i7.Customers? customer;

  static const _i10.Relation customerRelation = _i10.Relation(
    required: false,
    array: false,
    relatedCollection: '672bcb600030f54c04f0',
    relationType: _i10.RelationType.manyToOne,
    twoWay: true,
    twoWayKey: 'calendarEventParticipations',
    onDelete: _i10.RelationOnDelete.setNull,
    side: _i10.RelationSide.parent,
  );

  @override
  Map<String, dynamic> toJson() => {
        'event': event?.toJson(),
        'status': status.name,
        'customer': customer?.toJson(),
      };

  @override
  CalendarEventsParticipants copyWith({
    _i6.CalendarEvents? Function()? event,
    CalendarEventsParticipantsStatus Function()? status,
    _i7.Customers? Function()? customer,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      CalendarEventsParticipants._(
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        event: event != null ? event() : this.event,
        status: status != null ? status() : this.status,
        customer: customer != null ? customer() : this.customer,
      );

  @override
  Map<String, dynamic> toAppwrite({
    _i10.RelationContext? context,
    bool includeId = true,
  }) {
    final Map<String, dynamic> data = {};
    if (includeId && (context?.includeId ?? true)) data['\$id'] = $id;
    if (context?.includeData ?? true) {
      data['status'] = status.name;
    }
    if (context?['event'] != null) {
      data['event'] = event?.toAppwrite(context: context?['event']);
    }
    if (context?['customer'] != null) {
      data['customer'] = customer?.toAppwrite(context: context?['customer']);
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CalendarEventsParticipants) return false;
    return event == other.event &&
        status == other.status &&
        customer == other.customer;
  }

  @override
  int get hashCode => _hash([
        $id,
        event,
        status,
        customer,
      ]);

  static Future<
      _i11.Result<(int, List<CalendarEventsParticipants>),
          _i8.AppwriteException>> page({
    int limit = 25,
    int? offset,
    CalendarEventsParticipants? last,
    List<String>? queries,
  }) async =>
      _client.page<CalendarEventsParticipants>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: CalendarEventsParticipants.fromAppwrite,
        limit: limit,
        offset: offset,
        last: last,
        queries: queries,
      );

  Future<
      _i11.Result<(int, List<CalendarEventsParticipants>),
          _i8.AppwriteException>> list([List<String>? queries]) async =>
      _client.list<CalendarEventsParticipants>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: CalendarEventsParticipants.fromAppwrite,
        queries: queries,
      );

  static Future<_i11.Result<CalendarEventsParticipants, _i8.AppwriteException>>
      get(
    String documentId, {
    List<String>? queries,
  }) async =>
          _client.get<CalendarEventsParticipants>(
            databaseId: collectionInfo.databaseId,
            collectionId: collectionInfo.$id,
            fromAppwrite: CalendarEventsParticipants.fromAppwrite,
            documentId: documentId,
            queries: queries,
          );

  Future<_i11.Result<CalendarEventsParticipants, _i8.AppwriteException>> create(
          {_i10.RelationContext? context}) async =>
      _client.create<CalendarEventsParticipants>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: CalendarEventsParticipants.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i11.Result<CalendarEventsParticipants, _i8.AppwriteException>> update(
          {_i10.RelationContext? context}) async =>
      _client.update<CalendarEventsParticipants>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: CalendarEventsParticipants.fromAppwrite,
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

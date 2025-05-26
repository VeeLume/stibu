// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i1;
import 'package:stibu/models/appwrite_client.dart' as _i2;
import 'package:get_it/get_it.dart' as _i3;
import 'package:flutter/foundation.dart' as _i4;
import 'package:stibu/models/base.dart' as _i5;
import 'package:stibu/models/calendar_events_participants.dart' as _i6;
import 'package:stibu/models/invoices.dart' as _i7;
import 'package:appwrite/appwrite.dart' as _i8;
import 'package:appwrite/models.dart' as _i9;
import 'package:stibu/models/collections.dart' as _i10;
import 'package:result_type/result_type.dart' as _i11;

final _eq = const _i1.ListEquality().equals;
final _hash = const _i1.ListEquality().hash;
final _i2.AppwriteClient _client = _i3.GetIt.I<_i2.AppwriteClient>();

enum CalendarEventsType { plain, withParticipants }

@_i4.immutable
class CalendarEvents extends _i5.AppwriteModel<CalendarEvents> {
  const CalendarEvents._({
    required this.title,
    this.description,
    required this.start,
    required this.end,
    required this.type,
    this.amount,
    required this.participants,
    this.invoice,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  });

  factory CalendarEvents({
    required String title,
    String? description,
    required DateTime start,
    required DateTime end,
    required CalendarEventsType type,
    int? amount,
    List<_i6.CalendarEventsParticipants> participants = const [],
    _i7.Invoices? invoice,
  }) =>
      CalendarEvents._(
        title: title,
        description: description,
        start: start,
        end: end,
        type: type,
        amount: amount,
        participants: participants,
        invoice: invoice,
        $id: _i8.ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory CalendarEvents.fromAppwrite(_i9.Document doc) => CalendarEvents._(
        title: doc.data['title'],
        description: doc.data['description'],
        start: DateTime.parse(doc.data['start']),
        end: DateTime.parse(doc.data['end']),
        type: CalendarEventsType.values.byName(doc.data['type']),
        amount: doc.data['amount'],
        participants: List.unmodifiable(doc.data['participants']?.map((e) =>
                _i6.CalendarEventsParticipants.fromAppwrite(
                    _i9.Document.fromMap(e))) ??
            []),
        invoice: doc.data['invoice'] != null
            ? _i7.Invoices.fromAppwrite(
                _i9.Document.fromMap(doc.data['invoice']))
            : null,
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const _i10.CollectionInfo collectionInfo = _i10.CollectionInfo(
    $id: '672bce09001905da8109',
    $permissions: ['create("label:validProductKey")'],
    databaseId: '672bcb590033b5b2780a',
    name: 'CalendarEvents',
    enabled: true,
    documentSecurity: true,
  );

  final String title;

  final String? description;

  final DateTime start;

  final DateTime end;

  final CalendarEventsType type;

  final int? amount;

  final List<_i6.CalendarEventsParticipants> participants;

  static const _i10.Relation participantsRelation = _i10.Relation(
    required: false,
    array: true,
    relatedCollection: '672bcebb0002c448aa73',
    relationType: _i10.RelationType.oneToMany,
    twoWay: true,
    twoWayKey: 'event',
    onDelete: _i10.RelationOnDelete.cascade,
    side: _i10.RelationSide.parent,
  );

  final _i7.Invoices? invoice;

  static const _i10.Relation invoiceRelation = _i10.Relation(
    required: false,
    array: false,
    relatedCollection: '672bcbe40035299f5750',
    relationType: _i10.RelationType.oneToOne,
    twoWay: true,
    twoWayKey: 'calendarEvent',
    onDelete: _i10.RelationOnDelete.restrict,
    side: _i10.RelationSide.parent,
  );

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'type': type.name,
        'amount': amount,
        'participants': participants.map((e) => e.toJson()).toList(),
        'invoice': invoice?.toJson(),
      };

  @override
  CalendarEvents copyWith({
    String Function()? title,
    String? Function()? description,
    DateTime Function()? start,
    DateTime Function()? end,
    CalendarEventsType Function()? type,
    int? Function()? amount,
    List<_i6.CalendarEventsParticipants> Function()? participants,
    _i7.Invoices? Function()? invoice,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      CalendarEvents._(
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        title: title != null ? title() : this.title,
        description: description != null ? description() : this.description,
        start: start != null ? start() : this.start,
        end: end != null ? end() : this.end,
        type: type != null ? type() : this.type,
        amount: amount != null ? amount() : this.amount,
        participants: participants != null ? participants() : this.participants,
        invoice: invoice != null ? invoice() : this.invoice,
      );

  @override
  Map<String, dynamic> toAppwrite({
    _i10.RelationContext? context,
    bool includeId = true,
  }) {
    final Map<String, dynamic> data = {};
    if (includeId && (context?.includeId ?? true)) data['\$id'] = $id;
    if (context?.includeData ?? true) {
      data['title'] = title;
      data['description'] = description;
      data['start'] = start.toIso8601String();
      data['end'] = end.toIso8601String();
      data['type'] = type.name;
      data['amount'] = amount;
    }
    if (context?['participants'] != null) {
      data['participants'] = participants
          .map((e) => e.toAppwrite(context: context?['participants']))
          .toList();
    }
    if (context?['invoice'] != null) {
      data['invoice'] = invoice?.toAppwrite(context: context?['invoice']);
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CalendarEvents) return false;
    return title == other.title &&
        description == other.description &&
        start == other.start &&
        end == other.end &&
        type == other.type &&
        amount == other.amount &&
        _eq(participants, other.participants) &&
        invoice == other.invoice;
  }

  @override
  int get hashCode => _hash([
        $id,
        title,
        description,
        start,
        end,
        type,
        amount,
        ...(participants),
        invoice,
      ]);

  static Future<_i11.Result<(int, List<CalendarEvents>), _i8.AppwriteException>>
      page({
    int limit = 25,
    int? offset,
    CalendarEvents? last,
    List<String>? queries,
  }) async =>
          _client.page<CalendarEvents>(
            databaseId: collectionInfo.databaseId,
            collectionId: collectionInfo.$id,
            fromAppwrite: CalendarEvents.fromAppwrite,
            limit: limit,
            offset: offset,
            last: last,
            queries: queries,
          );

  Future<_i11.Result<(int, List<CalendarEvents>), _i8.AppwriteException>> list(
          [List<String>? queries]) async =>
      _client.list<CalendarEvents>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: CalendarEvents.fromAppwrite,
        queries: queries,
      );

  static Future<_i11.Result<CalendarEvents, _i8.AppwriteException>> get(
    String documentId, {
    List<String>? queries,
  }) async =>
      _client.get<CalendarEvents>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: CalendarEvents.fromAppwrite,
        documentId: documentId,
        queries: queries,
      );

  Future<_i11.Result<CalendarEvents, _i8.AppwriteException>> create(
          {_i10.RelationContext? context}) async =>
      _client.create<CalendarEvents>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: CalendarEvents.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i11.Result<CalendarEvents, _i8.AppwriteException>> update(
          {_i10.RelationContext? context}) async =>
      _client.update<CalendarEvents>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: CalendarEvents.fromAppwrite,
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

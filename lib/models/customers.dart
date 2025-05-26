// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i1;
import 'package:stibu/models/appwrite_client.dart' as _i2;
import 'package:get_it/get_it.dart' as _i3;
import 'package:flutter/foundation.dart' as _i4;
import 'package:stibu/models/base.dart' as _i5;
import 'package:stibu/models/calendar_events_participants.dart' as _i6;
import 'package:appwrite/appwrite.dart' as _i7;
import 'package:appwrite/models.dart' as _i8;
import 'package:stibu/models/collections.dart' as _i9;
import 'package:result_type/result_type.dart' as _i10;

final _eq = const _i1.ListEquality().equals;
final _hash = const _i1.ListEquality().hash;
final _i2.AppwriteClient _client = _i3.GetIt.I<_i2.AppwriteClient>();

@_i4.immutable
class Customers extends _i5.AppwriteModel<Customers> {
  const Customers._({
    required this.calendarEventParticipations,
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.street,
    this.zip,
    this.city,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  });

  factory Customers({
    List<_i6.CalendarEventsParticipants> calendarEventParticipations = const [],
    required int id,
    required String name,
    String? email,
    String? phone,
    String? street,
    String? zip,
    String? city,
  }) =>
      Customers._(
        calendarEventParticipations: calendarEventParticipations,
        id: id,
        name: name,
        email: email,
        phone: phone,
        street: street,
        zip: zip,
        city: city,
        $id: _i7.ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory Customers.fromAppwrite(_i8.Document doc) => Customers._(
        calendarEventParticipations: List.unmodifiable(doc
                .data['calendarEventParticipations']
                ?.map((e) => _i6.CalendarEventsParticipants.fromAppwrite(
                    _i8.Document.fromMap(e))) ??
            []),
        id: doc.data['id'],
        name: doc.data['name'],
        email: doc.data['email'],
        phone: doc.data['phone'],
        street: doc.data['street'],
        zip: doc.data['zip'],
        city: doc.data['city'],
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const _i9.CollectionInfo collectionInfo = _i9.CollectionInfo(
    $id: '672bcb600030f54c04f0',
    $permissions: ['create("label:validProductKey")'],
    databaseId: '672bcb590033b5b2780a',
    name: 'Customers',
    enabled: true,
    documentSecurity: true,
  );

  final List<_i6.CalendarEventsParticipants> calendarEventParticipations;

  static const _i9.Relation calendarEventParticipationsRelation = _i9.Relation(
    required: false,
    array: true,
    relatedCollection: '672bcebb0002c448aa73',
    relationType: _i9.RelationType.manyToOne,
    twoWay: true,
    twoWayKey: 'customer',
    onDelete: _i9.RelationOnDelete.setNull,
    side: _i9.RelationSide.child,
  );

  final int id;

  final String name;

  final String? email;

  final String? phone;

  final String? street;

  final String? zip;

  final String? city;

  @override
  Map<String, dynamic> toJson() => {
        'calendarEventParticipations':
            calendarEventParticipations.map((e) => e.toJson()).toList(),
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'street': street,
        'zip': zip,
        'city': city,
      };

  @override
  Customers copyWith({
    List<_i6.CalendarEventsParticipants> Function()?
        calendarEventParticipations,
    int Function()? id,
    String Function()? name,
    String? Function()? email,
    String? Function()? phone,
    String? Function()? street,
    String? Function()? zip,
    String? Function()? city,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      Customers._(
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        calendarEventParticipations: calendarEventParticipations != null
            ? calendarEventParticipations()
            : this.calendarEventParticipations,
        id: id != null ? id() : this.id,
        name: name != null ? name() : this.name,
        email: email != null ? email() : this.email,
        phone: phone != null ? phone() : this.phone,
        street: street != null ? street() : this.street,
        zip: zip != null ? zip() : this.zip,
        city: city != null ? city() : this.city,
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
      data['name'] = name;
      data['email'] = email;
      data['phone'] = phone;
      data['street'] = street;
      data['zip'] = zip;
      data['city'] = city;
    }
    if (context?['calendarEventParticipations'] != null) {
      data['calendarEventParticipations'] = calendarEventParticipations
          .map((e) =>
              e.toAppwrite(context: context?['calendarEventParticipations']))
          .toList();
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Customers) return false;
    return _eq(
            calendarEventParticipations, other.calendarEventParticipations) &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        street == other.street &&
        zip == other.zip &&
        city == other.city;
  }

  @override
  int get hashCode => _hash([
        $id,
        ...(calendarEventParticipations),
        id,
        name,
        email,
        phone,
        street,
        zip,
        city,
      ]);

  static Future<_i10.Result<(int, List<Customers>), _i7.AppwriteException>>
      page({
    int limit = 25,
    int? offset,
    Customers? last,
    List<String>? queries,
  }) async =>
          _client.page<Customers>(
            databaseId: collectionInfo.databaseId,
            collectionId: collectionInfo.$id,
            fromAppwrite: Customers.fromAppwrite,
            limit: limit,
            offset: offset,
            last: last,
            queries: queries,
          );

  Future<_i10.Result<(int, List<Customers>), _i7.AppwriteException>> list(
          [List<String>? queries]) async =>
      _client.list<Customers>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Customers.fromAppwrite,
        queries: queries,
      );

  static Future<_i10.Result<Customers, _i7.AppwriteException>> get(
    String documentId, {
    List<String>? queries,
  }) async =>
      _client.get<Customers>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Customers.fromAppwrite,
        documentId: documentId,
        queries: queries,
      );

  Future<_i10.Result<Customers, _i7.AppwriteException>> create(
          {_i9.RelationContext? context}) async =>
      _client.create<Customers>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Customers.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i10.Result<Customers, _i7.AppwriteException>> update(
          {_i9.RelationContext? context}) async =>
      _client.update<Customers>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Customers.fromAppwrite,
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

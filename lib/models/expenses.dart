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
class Expenses extends _i5.AppwriteModel<Expenses> {
  const Expenses._({
    required this.expenseNumber,
    required this.date,
    required this.name,
    this.notes,
    required this.amount,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  });

  factory Expenses({
    required String expenseNumber,
    required DateTime date,
    required String name,
    String? notes,
    required int amount,
  }) =>
      Expenses._(
        expenseNumber: expenseNumber,
        date: date,
        name: name,
        notes: notes,
        amount: amount,
        $id: _i6.ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory Expenses.fromAppwrite(_i7.Document doc) => Expenses._(
        expenseNumber: doc.data['expenseNumber'],
        date: DateTime.parse(doc.data['date']),
        name: doc.data['name'],
        notes: doc.data['notes'],
        amount: doc.data['amount'],
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const _i8.CollectionInfo collectionInfo = _i8.CollectionInfo(
    $id: '672bcd940039b63e4d29',
    $permissions: ['create("label:validProductKey")'],
    databaseId: '672bcb590033b5b2780a',
    name: 'Expenses',
    enabled: true,
    documentSecurity: true,
  );

  final String expenseNumber;

  final DateTime date;

  final String name;

  final String? notes;

  final int amount;

  @override
  Map<String, dynamic> toJson() => {
        'expenseNumber': expenseNumber,
        'date': date.toIso8601String(),
        'name': name,
        'notes': notes,
        'amount': amount,
      };

  @override
  Expenses copyWith({
    String Function()? expenseNumber,
    DateTime Function()? date,
    String Function()? name,
    String? Function()? notes,
    int Function()? amount,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      Expenses._(
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        expenseNumber:
            expenseNumber != null ? expenseNumber() : this.expenseNumber,
        date: date != null ? date() : this.date,
        name: name != null ? name() : this.name,
        notes: notes != null ? notes() : this.notes,
        amount: amount != null ? amount() : this.amount,
      );

  @override
  Map<String, dynamic> toAppwrite({
    _i8.RelationContext? context,
    bool includeId = true,
  }) {
    final Map<String, dynamic> data = {};
    if (includeId && (context?.includeId ?? true)) data['\$id'] = $id;
    if (context?.includeData ?? true) {
      data['expenseNumber'] = expenseNumber;
      data['date'] = date.toIso8601String();
      data['name'] = name;
      data['notes'] = notes;
      data['amount'] = amount;
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Expenses) return false;
    return expenseNumber == other.expenseNumber &&
        date == other.date &&
        name == other.name &&
        notes == other.notes &&
        amount == other.amount;
  }

  @override
  int get hashCode => _hash([
        $id,
        expenseNumber,
        date,
        name,
        notes,
        amount,
      ]);

  static Future<_i9.Result<(int, List<Expenses>), _i6.AppwriteException>> page({
    int limit = 25,
    int? offset,
    Expenses? last,
    List<String>? queries,
  }) async =>
      _client.page<Expenses>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Expenses.fromAppwrite,
        limit: limit,
        offset: offset,
        last: last,
        queries: queries,
      );

  Future<_i9.Result<(int, List<Expenses>), _i6.AppwriteException>> list(
          [List<String>? queries]) async =>
      _client.list<Expenses>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Expenses.fromAppwrite,
        queries: queries,
      );

  static Future<_i9.Result<Expenses, _i6.AppwriteException>> get(
    String documentId, {
    List<String>? queries,
  }) async =>
      _client.get<Expenses>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Expenses.fromAppwrite,
        documentId: documentId,
        queries: queries,
      );

  Future<_i9.Result<Expenses, _i6.AppwriteException>> create(
          {_i8.RelationContext? context}) async =>
      _client.create<Expenses>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Expenses.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i9.Result<Expenses, _i6.AppwriteException>> update(
          {_i8.RelationContext? context}) async =>
      _client.update<Expenses>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Expenses.fromAppwrite,
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

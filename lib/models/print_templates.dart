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

enum PrintTemplatesType { invoiceWithOrder, invoice, expense, monthlyReport }

@_i4.immutable
class PrintTemplates extends _i5.AppwriteModel<PrintTemplates> {
  const PrintTemplates._({
    required this.content,
    required this.name,
    this.filename,
    required this.type,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  });

  factory PrintTemplates({
    required String content,
    required String name,
    String? filename,
    List<PrintTemplatesType> type = const [],
  }) =>
      PrintTemplates._(
        content: content,
        name: name,
        filename: filename,
        type: type,
        $id: _i6.ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory PrintTemplates.fromAppwrite(_i7.Document doc) => PrintTemplates._(
        content: doc.data['content'],
        name: doc.data['name'],
        filename: doc.data['filename'],
        type: List<PrintTemplatesType>.unmodifiable(
            doc.data['type']?.map((e) => PrintTemplatesType.values.byName(e)) ??
                <PrintTemplatesType>[]),
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const _i8.CollectionInfo collectionInfo = _i8.CollectionInfo(
    $id: '67b28bbd0013cd7eff10',
    $permissions: ['create("label:validProductKey")'],
    databaseId: '672bcb590033b5b2780a',
    name: 'PrintTemplates',
    enabled: true,
    documentSecurity: true,
  );

  final String content;

  final String name;

  final String? filename;

  final List<PrintTemplatesType> type;

  @override
  Map<String, dynamic> toJson() => {
        'content': content,
        'name': name,
        'filename': filename,
        'type': type.map((e) => e.name).toList(),
      };

  @override
  PrintTemplates copyWith({
    String Function()? content,
    String Function()? name,
    String? Function()? filename,
    List<PrintTemplatesType> Function()? type,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      PrintTemplates._(
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        content: content != null ? content() : this.content,
        name: name != null ? name() : this.name,
        filename: filename != null ? filename() : this.filename,
        type: type != null ? type() : this.type,
      );

  @override
  Map<String, dynamic> toAppwrite({
    _i8.RelationContext? context,
    bool includeId = true,
  }) {
    final Map<String, dynamic> data = {};
    if (includeId && (context?.includeId ?? true)) data['\$id'] = $id;
    if (context?.includeData ?? true) {
      data['content'] = content;
      data['name'] = name;
      data['filename'] = filename;
      data['type'] = type.map((e) => e.name).toList();
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PrintTemplates) return false;
    return content == other.content &&
        name == other.name &&
        filename == other.filename &&
        _eq(type, other.type);
  }

  @override
  int get hashCode => _hash([
        $id,
        content,
        name,
        filename,
        ...(type),
      ]);

  static Future<_i9.Result<(int, List<PrintTemplates>), _i6.AppwriteException>>
      page({
    int limit = 25,
    int? offset,
    PrintTemplates? last,
    List<String>? queries,
  }) async =>
          _client.page<PrintTemplates>(
            databaseId: collectionInfo.databaseId,
            collectionId: collectionInfo.$id,
            fromAppwrite: PrintTemplates.fromAppwrite,
            limit: limit,
            offset: offset,
            last: last,
            queries: queries,
          );

  Future<_i9.Result<(int, List<PrintTemplates>), _i6.AppwriteException>> list(
          [List<String>? queries]) async =>
      _client.list<PrintTemplates>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: PrintTemplates.fromAppwrite,
        queries: queries,
      );

  static Future<_i9.Result<PrintTemplates, _i6.AppwriteException>> get(
    String documentId, {
    List<String>? queries,
  }) async =>
      _client.get<PrintTemplates>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: PrintTemplates.fromAppwrite,
        documentId: documentId,
        queries: queries,
      );

  Future<_i9.Result<PrintTemplates, _i6.AppwriteException>> create(
          {_i8.RelationContext? context}) async =>
      _client.create<PrintTemplates>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: PrintTemplates.fromAppwrite,
        model: this,
        context: context,
        permissions: _eq($permissions, collectionInfo.$permissions)
            ? null
            : $permissions,
      );

  Future<_i9.Result<PrintTemplates, _i6.AppwriteException>> update(
          {_i8.RelationContext? context}) async =>
      _client.update<PrintTemplates>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: PrintTemplates.fromAppwrite,
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

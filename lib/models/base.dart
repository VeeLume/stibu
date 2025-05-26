// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/foundation.dart' as _i1;
import 'package:stibu/models/collections.dart' as _i2;

@_i1.immutable
abstract class AppwriteModel<T> {
  const AppwriteModel({
    required this.$id,
    required this.$collectionId,
    required this.$databaseId,
    required this.$createdAt,
    required this.$updatedAt,
    required this.$permissions,
  });

  final String $id;

  final String $collectionId;

  final String $databaseId;

  final DateTime $createdAt;

  final DateTime $updatedAt;

  final List<String> $permissions;

  bool canRead() => $permissions.any((e) => e.contains('read'));

  bool canUpdate() => $permissions.any((e) => e.contains('update'));

  bool canDelete() => $permissions.any((e) => e.contains('delete'));

  bool canReadUpdate() => canRead() && canUpdate();

  Map<String, dynamic> toJson();
  T copyWith({
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  });
  @override
  String toString() => toJson().toString();

  dynamic toAppwrite({
    _i2.RelationContext? context,
    bool includeId = true,
  });
}

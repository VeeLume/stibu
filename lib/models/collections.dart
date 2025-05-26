// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/foundation.dart' as _i1;

@_i1.immutable
class CollectionInfo {
  const CollectionInfo({
    required this.$id,
    required this.$permissions,
    required this.databaseId,
    required this.name,
    required this.enabled,
    required this.documentSecurity,
  });

  final String $id;

  final List<String> $permissions;

  final String databaseId;

  final String name;

  final bool enabled;

  final bool documentSecurity;
}

@_i1.immutable
class Relation {
  const Relation({
    this.required = false,
    this.array = false,
    required this.relatedCollection,
    required this.relationType,
    this.twoWay = false,
    this.twoWayKey,
    required this.onDelete,
    required this.side,
  });

  final bool required;

  final bool array;

  final String relatedCollection;

  final RelationType relationType;

  final bool twoWay;

  final String? twoWayKey;

  final RelationOnDelete onDelete;

  final RelationSide side;
}

enum RelationType { oneToOne, oneToMany, manyToOne, manyToMany }

enum RelationOnDelete { cascade, setNull, restrict }

enum RelationSide { parent, child }

@_i1.immutable
class RelationContext {
  const RelationContext({
    this.children,
    this.includeId = true,
    this.includeData = true,
  });

  final Map<String, RelationContext>? children;

  final bool includeId;

  final bool includeData;

  RelationContext? operator [](String key) => children?[key];
}

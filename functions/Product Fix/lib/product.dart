import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';
import 'package:collection/collection.dart';
import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:result_type/result_type.dart';
import 'package:get_it/get_it.dart';


final _eq = const ListEquality().equals;
final _hash = const ListEquality().hash;
final _client = GetIt.I<AppwriteClient>();

class RLevel {
  RLevel({
    this.includeId = true,
    this.includeData = true,
    this.includePermissions = false,
    this.permissions = const [],
  });

  final bool includeId;

  final bool includeData;

  final bool includePermissions;

  final List<String> permissions;
}

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

  bool get canRead => $permissions.any((e) => e.contains('read'));

  bool get canUpdate => $permissions.any((e) => e.contains('update'));

  bool get canDelete => $permissions.any((e) => e.contains('delete'));

  bool get canReadUpdate => canRead && canUpdate;

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

  dynamic toAppwrite({List<RLevel> relationLevels = const []});
}

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

class Relation {
  const Relation({
    this.required = false,
    this.array = false,
    required this.relatedCollection,
    required this.relationType,
    this.twoWay = false,
    required this.twoWayKey,
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

enum RelationOnDelete { setNull, cascade, restrict }

enum RelationSide { parent, child }

class AppwriteClient {
  AppwriteClient(this.client)
      : account = Account(client),
        databases = Databases(client),
        functions = Functions(client),
        avatars = Avatars(client),
        storage = Storage(client);

  final Client client;

  final Account account;

  final Databases databases;

  final Functions functions;

  final Avatars avatars;

  final Storage storage;

  Future<Result<(int, List<T>), AppwriteException>>
      page<T extends AppwriteModel<T>>({
    required String databaseId,
    required String collectionId,
    required T Function(Document doc) fromAppwrite,
    int limit = 25,
    int? offset,
    T? last,
    List<String>? queries,
  }) async {
    assert(limit > 0, 'Limit must be greater than 0');
    assert(offset != null && offset >= 0 || last != null,
        'Either offset or last must be provided');
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.limit(limit),
          if (offset != null) Query.offset(offset),
          if (last != null) Query.cursorAfter(last.$id),
          ...?queries,
        ],
      );
      return Success((
        response.total,
        response.documents.map((e) => fromAppwrite(e)).toList(),
      ));
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<(int, List<T>), AppwriteException>> list<T extends AppwriteModel<T>>({
    required String databaseId,
    required String collectionId,
    required T Function(Document doc) fromAppwrite,
    List<String>? queries,
  }) async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: queries ?? [],
      );
      return Success((
        response.total,
        response.documents.map((e) => fromAppwrite(e)).toList(),
      ));
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<T, AppwriteException>> get<T extends AppwriteModel<T>>({
    required String databaseId,
    required String collectionId,
    required String documentId,
    required T Function(Document doc) fromAppwrite,
    List<String>? queries,
  }) async {
    try {
      final response = await databases.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        queries: queries,
      );
      return Success(fromAppwrite(response));
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<T, AppwriteException>> create<T extends AppwriteModel<T>>({
    required String databaseId,
    required String collectionId,
    required T Function(Document doc) fromAppwrite,
    required T model,
    List<RLevel> relationLevels = const [],
  }) async {
    try {
      final response = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: model.$id,
        data: model.toAppwrite(relationLevels: relationLevels),
        permissions: model.$permissions,
      );
      return Success(fromAppwrite(response));
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<T, AppwriteException>> update<T extends AppwriteModel<T>>({
    required String databaseId,
    required String collectionId,
    required T Function(Document doc) fromAppwrite,
    required T model,
    List<RLevel> relationLevels = const [],
  }) async {
    try {
      final response = await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: model.$id,
        data: model.toAppwrite(relationLevels: relationLevels),
        permissions: model.$permissions,
      );
      return Success(fromAppwrite(response));
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<void, AppwriteException>> delete({
    required String databaseId,
    required String collectionId,
    required String documentId,
  }) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
      return Success(null);
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }
}

class Products extends AppwriteModel<Products> {
  Products._({
    required this.id,
    required this.itemPrice,
    required this.qtyLimit,
    required this.originalItemPrice,
    required this.formattedItemPrice,
    required this.formattedOriginalItemPrice,
    required this.hasSalePrice,
    required this.launchDate,
    required this.endSaleDate,
    required this.beginSaleDate,
    required this.slug,
    required this.images,
    required this.title,
    required this.description,
    this.inventoryStatus,
    required this.culture,
    required this.color,
    required this.canBePurchased,
    required this.exclusiveTo,
    required this.categorySlugs,
    this.alternateId,
    this.replacementForItemId,
    this.hoverImage,
    this.metaDescription,
    this.metaTitle,
    required this.isCommissionable,
    required this.excludeFrom,
    required this.languages,
    required this.qualifier,
    required this.lifeCycleStates,
    required this.offeringType,
    required super.$id,
    required super.$collectionId,
    required super.$databaseId,
    required super.$createdAt,
    required super.$updatedAt,
    required super.$permissions,
  })  : assert(
            id >= -9223372036854775808, 'id is less than -9223372036854775808'),
        assert(id <= 9223372036854775807,
            'id is greater than 9223372036854775807'),
        assert(itemPrice >= -9223372036854775808,
            'itemPrice is less than -9223372036854775808'),
        assert(itemPrice <= 9223372036854775807,
            'itemPrice is greater than 9223372036854775807'),
        assert(qtyLimit >= -9223372036854775808,
            'qtyLimit is less than -9223372036854775808'),
        assert(qtyLimit <= 9223372036854775807,
            'qtyLimit is greater than 9223372036854775807'),
        assert(originalItemPrice >= -9223372036854775808,
            'originalItemPrice is less than -9223372036854775808'),
        assert(originalItemPrice <= 9223372036854775807,
            'originalItemPrice is greater than 9223372036854775807'),
        assert(formattedItemPrice.isNotBlank, 'formattedItemPrice is blank'),
        assert(formattedItemPrice.length <= 64,
            'formattedItemPrice is greater than 64'),
        assert(formattedOriginalItemPrice.isNotBlank,
            'formattedOriginalItemPrice is blank'),
        assert(formattedOriginalItemPrice.length <= 64,
            'formattedOriginalItemPrice is greater than 64'),
        assert(launchDate.isUtc, 'launchDate is not UTC'),
        assert(endSaleDate.isUtc, 'endSaleDate is not UTC'),
        assert(beginSaleDate.isUtc, 'beginSaleDate is not UTC'),
        assert(slug.isNotBlank, 'slug is blank'),
        assert(slug.length <= 1024, 'slug is greater than 1024'),
        assert(images.every((e) => e.isNotBlank), 'images is blank'),
        assert(
            images.every((e) => e.length <= 64), 'images is greater than 64'),
        assert(title.isNotBlank, 'title is blank'),
        assert(title.length <= 1024, 'title is greater than 1024'),
        assert(description.isNotBlank, 'description is blank'),
        assert(description.length <= 4096, 'description is greater than 4096'),
        assert(inventoryStatus == null || inventoryStatus.isNotBlank,
            'inventoryStatus is blank'),
        assert(inventoryStatus == null || inventoryStatus.length <= 64,
            'inventoryStatus is greater than 64'),
        assert(culture.isNotBlank, 'culture is blank'),
        assert(culture.length <= 64, 'culture is greater than 64'),
        assert(color.every((e) => e.isNotBlank), 'color is blank'),
        assert(color.every((e) => e.length <= 64), 'color is greater than 64'),
        assert(exclusiveTo.every((e) => e.isNotBlank), 'exclusiveTo is blank'),
        assert(exclusiveTo.every((e) => e.length <= 64),
            'exclusiveTo is greater than 64'),
        assert(
            categorySlugs.every((e) => e.isNotBlank), 'categorySlugs is blank'),
        assert(categorySlugs.every((e) => e.length <= 1024),
            'categorySlugs is greater than 1024'),
        assert(alternateId == null || alternateId.isNotBlank,
            'alternateId is blank'),
        assert(alternateId == null || alternateId.length <= 64,
            'alternateId is greater than 64'),
        assert(
            replacementForItemId == null ||
                replacementForItemId >= -9223372036854775808,
            'replacementForItemId is less than -9223372036854775808'),
        assert(
            replacementForItemId == null ||
                replacementForItemId <= 9223372036854775807,
            'replacementForItemId is greater than 9223372036854775807'),
        assert(
            hoverImage == null || hoverImage.isNotBlank, 'hoverImage is blank'),
        assert(hoverImage == null || hoverImage.length <= 1024,
            'hoverImage is greater than 1024'),
        assert(metaDescription == null || metaDescription.isNotBlank,
            'metaDescription is blank'),
        assert(metaDescription == null || metaDescription.length <= 4096,
            'metaDescription is greater than 4096'),
        assert(metaTitle == null || metaTitle.isNotBlank, 'metaTitle is blank'),
        assert(metaTitle == null || metaTitle.length <= 1024,
            'metaTitle is greater than 1024'),
        assert(excludeFrom.every((e) => e.isNotBlank), 'excludeFrom is blank'),
        assert(excludeFrom.every((e) => e.length <= 64),
            'excludeFrom is greater than 64'),
        assert(languages.every((e) => e.isNotBlank), 'languages is blank'),
        assert(languages.every((e) => e.length <= 64),
            'languages is greater than 64'),
        assert(qualifier.every((e) => e.isNotBlank), 'qualifier is blank'),
        assert(qualifier.every((e) => e.length <= 64),
            'qualifier is greater than 64'),
        assert(lifeCycleStates.every((e) => e.isNotBlank),
            'lifeCycleStates is blank'),
        assert(lifeCycleStates.every((e) => e.length <= 64),
            'lifeCycleStates is greater than 64'),
        assert(offeringType.isNotBlank, 'offeringType is blank'),
        assert(offeringType.length <= 64, 'offeringType is greater than 64');

  factory Products({
    required int id,
    required int itemPrice,
    required int qtyLimit,
    required int originalItemPrice,
    required String formattedItemPrice,
    required String formattedOriginalItemPrice,
    required bool hasSalePrice,
    required DateTime launchDate,
    required DateTime endSaleDate,
    required DateTime beginSaleDate,
    required String slug,
    required List<String> images,
    required String title,
    required String description,
    String? inventoryStatus,
    required String culture,
    required List<String> color,
    required bool canBePurchased,
    required List<String> exclusiveTo,
    required List<String> categorySlugs,
    String? alternateId,
    int? replacementForItemId,
    String? hoverImage,
    String? metaDescription,
    String? metaTitle,
    required bool isCommissionable,
    required List<String> excludeFrom,
    required List<String> languages,
    required List<String> qualifier,
    required List<String> lifeCycleStates,
    required String offeringType,
  }) =>
      Products._(
        id: id,
        itemPrice: itemPrice,
        qtyLimit: qtyLimit,
        originalItemPrice: originalItemPrice,
        formattedItemPrice: formattedItemPrice,
        formattedOriginalItemPrice: formattedOriginalItemPrice,
        hasSalePrice: hasSalePrice,
        launchDate: launchDate,
        endSaleDate: endSaleDate,
        beginSaleDate: beginSaleDate,
        slug: slug,
        images: images,
        title: title,
        description: description,
        inventoryStatus: inventoryStatus,
        culture: culture,
        color: color,
        canBePurchased: canBePurchased,
        exclusiveTo: exclusiveTo,
        categorySlugs: categorySlugs,
        alternateId: alternateId,
        replacementForItemId: replacementForItemId,
        hoverImage: hoverImage,
        metaDescription: metaDescription,
        metaTitle: metaTitle,
        isCommissionable: isCommissionable,
        excludeFrom: excludeFrom,
        languages: languages,
        qualifier: qualifier,
        lifeCycleStates: lifeCycleStates,
        offeringType: offeringType,
        $id: ID.unique(),
        $collectionId: collectionInfo.$id,
        $databaseId: collectionInfo.databaseId,
        $createdAt: DateTime.now().toUtc(),
        $updatedAt: DateTime.now().toUtc(),
        $permissions: collectionInfo.$permissions,
      );

  factory Products.fromAppwrite(Document doc) => Products._(
        id: doc.data['id'],
        itemPrice: doc.data['itemPrice'],
        qtyLimit: doc.data['qtyLimit'],
        originalItemPrice: doc.data['originalItemPrice'],
        formattedItemPrice: doc.data['formattedItemPrice'],
        formattedOriginalItemPrice: doc.data['formattedOriginalItemPrice'],
        hasSalePrice: doc.data['hasSalePrice'],
        launchDate: DateTime.parse(doc.data['launchDate']),
        endSaleDate: DateTime.parse(doc.data['endSaleDate']),
        beginSaleDate: DateTime.parse(doc.data['beginSaleDate']),
        slug: doc.data['slug'],
        images: List<String>.unmodifiable(doc.data['images'] ?? []),
        title: doc.data['title'],
        description: doc.data['description'],
        inventoryStatus: doc.data['inventoryStatus'],
        culture: doc.data['culture'],
        color: List<String>.unmodifiable(doc.data['color'] ?? []),
        canBePurchased: doc.data['canBePurchased'],
        exclusiveTo: List<String>.unmodifiable(doc.data['exclusiveTo'] ?? []),
        categorySlugs:
            List<String>.unmodifiable(doc.data['categorySlugs'] ?? []),
        alternateId: doc.data['alternateId'],
        replacementForItemId: doc.data['replacementForItemId'],
        hoverImage: doc.data['hoverImage'],
        metaDescription: doc.data['metaDescription'],
        metaTitle: doc.data['metaTitle'],
        isCommissionable: doc.data['isCommissionable'],
        excludeFrom: List<String>.unmodifiable(doc.data['excludeFrom'] ?? []),
        languages: List<String>.unmodifiable(doc.data['languages'] ?? []),
        qualifier: List<String>.unmodifiable(doc.data['qualifier'] ?? []),
        lifeCycleStates:
            List<String>.unmodifiable(doc.data['lifeCycleStates'] ?? []),
        offeringType: doc.data['offeringType'],
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: toList(doc.$permissions),
      );

  static const CollectionInfo collectionInfo = CollectionInfo(
    $id: 'products',
    $permissions: ['read("users")'],
    databaseId: 'public',
    name: 'products',
    enabled: true,
    documentSecurity: false,
  );

  final int id;

  final int itemPrice;

  final int qtyLimit;

  final int originalItemPrice;

  final String formattedItemPrice;

  final String formattedOriginalItemPrice;

  final bool hasSalePrice;

  final DateTime launchDate;

  final DateTime endSaleDate;

  final DateTime beginSaleDate;

  final String slug;

  final List<String> images;

  final String title;

  final String description;

  final String? inventoryStatus;

  final String culture;

  final List<String> color;

  final bool canBePurchased;

  final List<String> exclusiveTo;

  final List<String> categorySlugs;

  final String? alternateId;

  final int? replacementForItemId;

  final String? hoverImage;

  final String? metaDescription;

  final String? metaTitle;

  final bool isCommissionable;

  final List<String> excludeFrom;

  final List<String> languages;

  final List<String> qualifier;

  final List<String> lifeCycleStates;

  final String offeringType;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'itemPrice': itemPrice,
        'qtyLimit': qtyLimit,
        'originalItemPrice': originalItemPrice,
        'formattedItemPrice': formattedItemPrice,
        'formattedOriginalItemPrice': formattedOriginalItemPrice,
        'hasSalePrice': hasSalePrice,
        'launchDate': launchDate.toIso8601String(),
        'endSaleDate': endSaleDate.toIso8601String(),
        'beginSaleDate': beginSaleDate.toIso8601String(),
        'slug': slug,
        'images': images,
        'title': title,
        'description': description,
        'inventoryStatus': inventoryStatus,
        'culture': culture,
        'color': color,
        'canBePurchased': canBePurchased,
        'exclusiveTo': exclusiveTo,
        'categorySlugs': categorySlugs,
        'alternateId': alternateId,
        'replacementForItemId': replacementForItemId,
        'hoverImage': hoverImage,
        'metaDescription': metaDescription,
        'metaTitle': metaTitle,
        'isCommissionable': isCommissionable,
        'excludeFrom': excludeFrom,
        'languages': languages,
        'qualifier': qualifier,
        'lifeCycleStates': lifeCycleStates,
        'offeringType': offeringType
      };

  @override
  dynamic toAppwrite({List<RLevel> relationLevels = const []}) {
    final rInfo = relationLevels.isNotEmpty ? relationLevels.first : null;
    final hasRInfo = rInfo != null;
    var data = <String, dynamic>{};
    if (hasRInfo && rInfo.includeId) data['\$id'] = $id;
    if (hasRInfo && rInfo.includeData) {
      data = {
        ...data,
        ...{
          'id': id,
          'itemPrice': itemPrice,
          'qtyLimit': qtyLimit,
          'originalItemPrice': originalItemPrice,
          'formattedItemPrice': formattedItemPrice,
          'formattedOriginalItemPrice': formattedOriginalItemPrice,
          'hasSalePrice': hasSalePrice,
          'launchDate': launchDate.toIso8601String(),
          'endSaleDate': endSaleDate.toIso8601String(),
          'beginSaleDate': beginSaleDate.toIso8601String(),
          'slug': slug,
          'images': images,
          'title': title,
          'description': description,
          'inventoryStatus': inventoryStatus,
          'culture': culture,
          'color': color,
          'canBePurchased': canBePurchased,
          'exclusiveTo': exclusiveTo,
          'categorySlugs': categorySlugs,
          'alternateId': alternateId,
          'replacementForItemId': replacementForItemId,
          'hoverImage': hoverImage,
          'metaDescription': metaDescription,
          'metaTitle': metaTitle,
          'isCommissionable': isCommissionable,
          'excludeFrom': excludeFrom,
          'languages': languages,
          'qualifier': qualifier,
          'lifeCycleStates': lifeCycleStates,
          'offeringType': offeringType
        }
      };
    } else if (!hasRInfo) {
      data = {
        'id': id,
        'itemPrice': itemPrice,
        'qtyLimit': qtyLimit,
        'originalItemPrice': originalItemPrice,
        'formattedItemPrice': formattedItemPrice,
        'formattedOriginalItemPrice': formattedOriginalItemPrice,
        'hasSalePrice': hasSalePrice,
        'launchDate': launchDate.toIso8601String(),
        'endSaleDate': endSaleDate.toIso8601String(),
        'beginSaleDate': beginSaleDate.toIso8601String(),
        'slug': slug,
        'images': images,
        'title': title,
        'description': description,
        'inventoryStatus': inventoryStatus,
        'culture': culture,
        'color': color,
        'canBePurchased': canBePurchased,
        'exclusiveTo': exclusiveTo,
        'categorySlugs': categorySlugs,
        'alternateId': alternateId,
        'replacementForItemId': replacementForItemId,
        'hoverImage': hoverImage,
        'metaDescription': metaDescription,
        'metaTitle': metaTitle,
        'isCommissionable': isCommissionable,
        'excludeFrom': excludeFrom,
        'languages': languages,
        'qualifier': qualifier,
        'lifeCycleStates': lifeCycleStates,
        'offeringType': offeringType
      };
    }
    if (hasRInfo && rInfo.includePermissions) {
      data['\$permissions'] = $permissions;
    }
    if (hasRInfo &&
        rInfo.includeId &&
        !rInfo.includeData &&
        !rInfo.includePermissions) {
      return $id;
    } else {
      return data;
    }
  }

  @override
  Products copyWith({
    int Function()? id,
    int Function()? itemPrice,
    int Function()? qtyLimit,
    int Function()? originalItemPrice,
    String Function()? formattedItemPrice,
    String Function()? formattedOriginalItemPrice,
    bool Function()? hasSalePrice,
    DateTime Function()? launchDate,
    DateTime Function()? endSaleDate,
    DateTime Function()? beginSaleDate,
    String Function()? slug,
    List<String> Function()? images,
    String Function()? title,
    String Function()? description,
    String? Function()? inventoryStatus,
    String Function()? culture,
    List<String> Function()? color,
    bool Function()? canBePurchased,
    List<String> Function()? exclusiveTo,
    List<String> Function()? categorySlugs,
    String? Function()? alternateId,
    int? Function()? replacementForItemId,
    String? Function()? hoverImage,
    String? Function()? metaDescription,
    String? Function()? metaTitle,
    bool Function()? isCommissionable,
    List<String> Function()? excludeFrom,
    List<String> Function()? languages,
    List<String> Function()? qualifier,
    List<String> Function()? lifeCycleStates,
    String Function()? offeringType,
    String? $id,
    String? $collectionId,
    String? $databaseId,
    DateTime? $createdAt,
    DateTime? $updatedAt,
    List<String>? $permissions,
  }) =>
      Products._(
        id: id?.call() ?? this.id,
        itemPrice: itemPrice?.call() ?? this.itemPrice,
        qtyLimit: qtyLimit?.call() ?? this.qtyLimit,
        originalItemPrice: originalItemPrice?.call() ?? this.originalItemPrice,
        formattedItemPrice:
            formattedItemPrice?.call() ?? this.formattedItemPrice,
        formattedOriginalItemPrice: formattedOriginalItemPrice?.call() ??
            this.formattedOriginalItemPrice,
        hasSalePrice: hasSalePrice?.call() ?? this.hasSalePrice,
        launchDate: launchDate?.call() ?? this.launchDate,
        endSaleDate: endSaleDate?.call() ?? this.endSaleDate,
        beginSaleDate: beginSaleDate?.call() ?? this.beginSaleDate,
        slug: slug?.call() ?? this.slug,
        images: images?.call() ?? this.images,
        title: title?.call() ?? this.title,
        description: description?.call() ?? this.description,
        inventoryStatus: inventoryStatus!.call(),
        culture: culture?.call() ?? this.culture,
        color: color?.call() ?? this.color,
        canBePurchased: canBePurchased?.call() ?? this.canBePurchased,
        exclusiveTo: exclusiveTo?.call() ?? this.exclusiveTo,
        categorySlugs: categorySlugs?.call() ?? this.categorySlugs,
        alternateId: alternateId?.call() ?? this.alternateId,
        replacementForItemId:
            replacementForItemId?.call() ?? this.replacementForItemId,
        hoverImage: hoverImage?.call() ?? this.hoverImage,
        metaDescription: metaDescription?.call() ?? this.metaDescription,
        metaTitle: metaTitle?.call() ?? this.metaTitle,
        isCommissionable: isCommissionable?.call() ?? this.isCommissionable,
        excludeFrom: excludeFrom?.call() ?? this.excludeFrom,
        languages: languages?.call() ?? this.languages,
        qualifier: qualifier?.call() ?? this.qualifier,
        lifeCycleStates: lifeCycleStates?.call() ?? this.lifeCycleStates,
        offeringType: offeringType?.call() ?? this.offeringType,
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
      );

  @override
  bool operator ==(Object other) =>
      other is Products &&
      id == other.id &&
      itemPrice == other.itemPrice &&
      qtyLimit == other.qtyLimit &&
      originalItemPrice == other.originalItemPrice &&
      formattedItemPrice == other.formattedItemPrice &&
      formattedOriginalItemPrice == other.formattedOriginalItemPrice &&
      hasSalePrice == other.hasSalePrice &&
      launchDate == other.launchDate &&
      endSaleDate == other.endSaleDate &&
      beginSaleDate == other.beginSaleDate &&
      slug == other.slug &&
      _eq(images, other.images) &&
      title == other.title &&
      description == other.description &&
      inventoryStatus == other.inventoryStatus &&
      culture == other.culture &&
      _eq(color, other.color) &&
      canBePurchased == other.canBePurchased &&
      _eq(exclusiveTo, other.exclusiveTo) &&
      _eq(categorySlugs, other.categorySlugs) &&
      alternateId == other.alternateId &&
      replacementForItemId == other.replacementForItemId &&
      hoverImage == other.hoverImage &&
      metaDescription == other.metaDescription &&
      metaTitle == other.metaTitle &&
      isCommissionable == other.isCommissionable &&
      _eq(excludeFrom, other.excludeFrom) &&
      _eq(languages, other.languages) &&
      _eq(qualifier, other.qualifier) &&
      _eq(lifeCycleStates, other.lifeCycleStates) &&
      offeringType == other.offeringType;

  @override
  int get hashCode => _hash([
        id,
        itemPrice,
        qtyLimit,
        originalItemPrice,
        formattedItemPrice,
        formattedOriginalItemPrice,
        hasSalePrice,
        launchDate,
        endSaleDate,
        beginSaleDate,
        slug,
        ...(images),
        title,
        description,
        inventoryStatus,
        culture,
        ...(color),
        canBePurchased,
        ...(exclusiveTo),
        ...(categorySlugs),
        alternateId,
        replacementForItemId,
        hoverImage,
        metaDescription,
        metaTitle,
        isCommissionable,
        ...(excludeFrom),
        ...(languages),
        ...(qualifier),
        ...(lifeCycleStates),
        offeringType
      ]);

  static Future<Result<(int, List<Products>), AppwriteException>> page({
    int limit = 25,
    int? offset,
    Products? last,
    List<String>? queries,
  }) async =>
      _client.page<Products>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Products.fromAppwrite,
        limit: limit,
        offset: offset,
        last: last,
        queries: queries,
      );

  Future<Result<(int, List<Products>), AppwriteException>> list(
          [List<String>? queries]) async =>
      _client.list<Products>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Products.fromAppwrite,
        queries: queries,
      );

  static Future<Result<Products, AppwriteException>> get(
    String documentId, {
    List<String>? queries,
  }) async =>
      _client.get<Products>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Products.fromAppwrite,
        documentId: documentId,
        queries: queries,
      );

  Future<Result<Products, AppwriteException>> create(
          {List<RLevel> relationLevels = const []}) async =>
      _client.create<Products>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Products.fromAppwrite,
        model: this,
        relationLevels: relationLevels,
      );

  Future<Result<Products, AppwriteException>> update(
          {List<RLevel> relationLevels = const []}) async =>
      _client.update<Products>(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        fromAppwrite: Products.fromAppwrite,
        model: this,
        relationLevels: relationLevels,
      );

  Future<Result<void, AppwriteException>> delete() async => _client.delete(
        databaseId: collectionInfo.databaseId,
        collectionId: collectionInfo.$id,
        documentId: $id,
      );
}

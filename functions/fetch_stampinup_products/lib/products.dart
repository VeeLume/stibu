import 'package:collection/collection.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';

final _eq = const ListEquality().equals;
final _hash = const ListEquality().hash;

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
    RelationContext? context,
    bool includeId = true,
  });
}

class Products extends AppwriteModel<Products> {
  const Products._({
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
  });

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
    List<String> images = const [],
    required String title,
    required String description,
    String? inventoryStatus,
    required String culture,
    List<String> color = const [],
    required bool canBePurchased,
    List<String> exclusiveTo = const [],
    List<String> categorySlugs = const [],
    String? alternateId,
    int? replacementForItemId,
    String? hoverImage,
    String? metaDescription,
    String? metaTitle,
    required bool isCommissionable,
    List<String> excludeFrom = const [],
    List<String> languages = const [],
    List<String> qualifier = const [],
    List<String> lifeCycleStates = const [],
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
        images: List.unmodifiable(doc.data['images'] ?? []),
        title: doc.data['title'],
        description: doc.data['description'],
        inventoryStatus: doc.data['inventoryStatus'],
        culture: doc.data['culture'],
        color: List.unmodifiable(doc.data['color'] ?? []),
        canBePurchased: doc.data['canBePurchased'],
        exclusiveTo: List.unmodifiable(doc.data['exclusiveTo'] ?? []),
        categorySlugs: List.unmodifiable(doc.data['categorySlugs'] ?? []),
        alternateId: doc.data['alternateId'],
        replacementForItemId: doc.data['replacementForItemId'],
        hoverImage: doc.data['hoverImage'],
        metaDescription: doc.data['metaDescription'],
        metaTitle: doc.data['metaTitle'],
        isCommissionable: doc.data['isCommissionable'],
        excludeFrom: List.unmodifiable(doc.data['excludeFrom'] ?? []),
        languages: List.unmodifiable(doc.data['languages'] ?? []),
        qualifier: List.unmodifiable(doc.data['qualifier'] ?? []),
        lifeCycleStates: List.unmodifiable(doc.data['lifeCycleStates'] ?? []),
        offeringType: doc.data['offeringType'],
        $id: doc.$id,
        $collectionId: doc.$collectionId,
        $databaseId: doc.$databaseId,
        $createdAt: DateTime.parse(doc.$createdAt),
        $updatedAt: DateTime.parse(doc.$updatedAt),
        $permissions: doc.$permissions,
      );

  static const CollectionInfo collectionInfo = CollectionInfo(
    $id: 'products',
    $permissions: ['read("users")'],
    databaseId: 'public',
    name: 'Products',
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
        'offeringType': offeringType,
      };

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
        $id: $id ?? this.$id,
        $collectionId: $collectionId ?? this.$collectionId,
        $databaseId: $databaseId ?? this.$databaseId,
        $createdAt: $createdAt ?? this.$createdAt,
        $updatedAt: $updatedAt ?? this.$updatedAt,
        $permissions: $permissions ?? this.$permissions,
        id: id != null ? id() : this.id,
        itemPrice: itemPrice != null ? itemPrice() : this.itemPrice,
        qtyLimit: qtyLimit != null ? qtyLimit() : this.qtyLimit,
        originalItemPrice: originalItemPrice != null
            ? originalItemPrice()
            : this.originalItemPrice,
        formattedItemPrice: formattedItemPrice != null
            ? formattedItemPrice()
            : this.formattedItemPrice,
        formattedOriginalItemPrice: formattedOriginalItemPrice != null
            ? formattedOriginalItemPrice()
            : this.formattedOriginalItemPrice,
        hasSalePrice: hasSalePrice != null ? hasSalePrice() : this.hasSalePrice,
        launchDate: launchDate != null ? launchDate() : this.launchDate,
        endSaleDate: endSaleDate != null ? endSaleDate() : this.endSaleDate,
        beginSaleDate:
            beginSaleDate != null ? beginSaleDate() : this.beginSaleDate,
        slug: slug != null ? slug() : this.slug,
        images: images != null ? images() : this.images,
        title: title != null ? title() : this.title,
        description: description != null ? description() : this.description,
        inventoryStatus:
            inventoryStatus != null ? inventoryStatus() : this.inventoryStatus,
        culture: culture != null ? culture() : this.culture,
        color: color != null ? color() : this.color,
        canBePurchased:
            canBePurchased != null ? canBePurchased() : this.canBePurchased,
        exclusiveTo: exclusiveTo != null ? exclusiveTo() : this.exclusiveTo,
        categorySlugs:
            categorySlugs != null ? categorySlugs() : this.categorySlugs,
        alternateId: alternateId != null ? alternateId() : this.alternateId,
        replacementForItemId: replacementForItemId != null
            ? replacementForItemId()
            : this.replacementForItemId,
        hoverImage: hoverImage != null ? hoverImage() : this.hoverImage,
        metaDescription:
            metaDescription != null ? metaDescription() : this.metaDescription,
        metaTitle: metaTitle != null ? metaTitle() : this.metaTitle,
        isCommissionable: isCommissionable != null
            ? isCommissionable()
            : this.isCommissionable,
        excludeFrom: excludeFrom != null ? excludeFrom() : this.excludeFrom,
        languages: languages != null ? languages() : this.languages,
        qualifier: qualifier != null ? qualifier() : this.qualifier,
        lifeCycleStates:
            lifeCycleStates != null ? lifeCycleStates() : this.lifeCycleStates,
        offeringType: offeringType != null ? offeringType() : this.offeringType,
      );

  @override
  Map<String, dynamic> toAppwrite({
    RelationContext? context,
    bool includeId = true,
  }) {
    final Map<String, dynamic> data = {};
    if (includeId && (context?.includeId ?? true)) data['\$id'] = $id;
    if (context?.includeData ?? true) {
      data['id'] = id;
      data['itemPrice'] = itemPrice;
      data['qtyLimit'] = qtyLimit;
      data['originalItemPrice'] = originalItemPrice;
      data['formattedItemPrice'] = formattedItemPrice;
      data['formattedOriginalItemPrice'] = formattedOriginalItemPrice;
      data['hasSalePrice'] = hasSalePrice;
      data['launchDate'] = launchDate.toIso8601String();
      data['endSaleDate'] = endSaleDate.toIso8601String();
      data['beginSaleDate'] = beginSaleDate.toIso8601String();
      data['slug'] = slug;
      data['images'] = images;
      data['title'] = title;
      data['description'] = description;
      data['inventoryStatus'] = inventoryStatus;
      data['culture'] = culture;
      data['color'] = color;
      data['canBePurchased'] = canBePurchased;
      data['exclusiveTo'] = exclusiveTo;
      data['categorySlugs'] = categorySlugs;
      data['alternateId'] = alternateId;
      data['replacementForItemId'] = replacementForItemId;
      data['hoverImage'] = hoverImage;
      data['metaDescription'] = metaDescription;
      data['metaTitle'] = metaTitle;
      data['isCommissionable'] = isCommissionable;
      data['excludeFrom'] = excludeFrom;
      data['languages'] = languages;
      data['qualifier'] = qualifier;
      data['lifeCycleStates'] = lifeCycleStates;
      data['offeringType'] = offeringType;
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Products) return false;
    return id == other.id &&
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
  }

  @override
  int get hashCode => _hash([
        $id,
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
        offeringType,
      ]);
}

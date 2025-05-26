import 'package:appwrite/appwrite.dart';
import 'package:result_type/result_type.dart';
import 'package:stibu/core/currency.dart';
import 'package:stibu/core/new_ids.dart';
import 'package:stibu/main.dart';
import 'package:stibu/models/appwrite_client.dart';
import 'package:stibu/models/calendar_events.dart';
import 'package:stibu/models/calendar_events_participants.dart';
import 'package:stibu/models/collections.dart';
import 'package:stibu/models/customers.dart';
import 'package:stibu/models/invoices.dart';
import 'package:stibu/models/order_coupons.dart';
import 'package:stibu/models/order_products.dart';
import 'package:stibu/models/orders.dart';
import 'package:stibu/models/products.dart';
import 'package:watch_it/watch_it.dart';

extension OrderProductsExtension on OrderProducts {
  Currency get total => price.currency * quantity;
}

extension ProductsExtension on Products {
  String? get imageUrl =>
      images.isEmpty
          ? null
          : 'https://res.cloudinary.com/stampin-up/image/upload/q_auto:best,f_auto/bo_1px_solid_rgb:cccccc/w_3200,q_60,f_auto,d_missing_image.png/v1/prod/images/default-source/product-image/${images.first}';
}

extension CurrencyExtensions on int {
  Currency get currency => Currency(this);
}

extension CustomersExtensions on Customers {
  String get address => '$street, $zip $city';
  String get zipWithCityFormatted => '$zip $city';
}

extension OrdersExtensions on Orders {
  Currency get productsTotal => products.fold<Currency>(
    const Currency.zero(),
    (value, product) => value + product.total,
  );

  Currency get couponsTotal => coupons.fold<Currency>(
    const Currency.zero(),
    (value, coupon) => value + coupon.amount.currency,
  );

  Currency get total => productsTotal - couponsTotal;

  Future<Result<Invoices, AppwriteException>> createInvoice({
    DateTime? date,
    String? note,
  }) async {
    final appwrite = di<AppwriteClient>();
    try {
      final invoiceId = await newInvoiceNumber(date);
      if (invoiceId.isFailure) return Failure(invoiceId.failure);
      final user = await appwrite.account.get();

      final permissions = [Permission.read(Role.user(user.$id))];

      final doc = await appwrite.databases.createDocument(
        databaseId: Invoices.collectionInfo.databaseId,
        collectionId: Invoices.collectionInfo.$id,
        documentId: ID.unique(),
        data: {
          'invoiceNumber': invoiceId.success,
          'date': date?.toIso8601String() ?? DateTime.now().toIso8601String(),
          'name': 'Invoice ${invoiceId.success}',
          'amount': total.asInt,
          'notes': note,
          'order': $id,
        },
        permissions: permissions,
      );

      // Set order, orderProducts and orderCoupons permissions to read-only
      await appwrite.databases.updateDocument(
        databaseId: Orders.collectionInfo.databaseId,
        collectionId: Orders.collectionInfo.$id,
        documentId: $id,
        permissions: permissions,
        data: {
          'products':
              products
                  .map(
                    (product) => {
                      '\$id': product.$id,
                      '\$permissions': permissions,
                    },
                  )
                  .toList(),
          'coupons':
              coupons
                  .map(
                    (coupon) => {
                      '\$id': coupon.$id,
                      '\$permissions': permissions,
                    },
                  )
                  .toList(),
        },
      );

      return Success(Invoices.fromAppwrite(doc));
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<Orders, AppwriteException>> addCoupon(
    OrderCoupons coupon,
  ) async {
    final newCoupons = <OrderCoupons>[...(coupons), coupon];
    final result = await copyWith(coupons: () => newCoupons).update(
      context: RelationContext(
        includeId: false,
        children: {'coupons': RelationContext(), 'products': RelationContext()},
      ),
    );
    if (result.isFailure) return Failure(result.failure);

    return Success(result.success);
  }

  Future<Result<Orders, AppwriteException>> deleteCoupon(
    OrderCoupons coupon,
  ) async {
    final newCoupons = copyWith(
      coupons: () => coupons.where((c) => c.$id != coupon.$id).toList(),
    );

    final order = await copyWith(coupons: () => newCoupons.coupons).update(
      context: RelationContext(
        includeId: false,
        children: {'coupons': RelationContext(), 'products': RelationContext()},
      ),
    );
    if (order.isFailure) return Failure(order.failure);

    final result = await coupon.delete();
    if (result.isFailure) return Failure(result.failure);

    return Success(order.success);
  }

  Future<Result<Orders, AppwriteException>> updateCoupon(
    OrderCoupons coupon,
  ) async {
    final newCoupons =
        coupons.map((c) {
          if (c.$id == coupon.$id) return coupon;
          return c;
        }).toList();

    final result = await copyWith(coupons: () => newCoupons).update(
      context: RelationContext(
        includeId: false,
        children: {'coupons': RelationContext(), 'products': RelationContext()},
      ),
    );
    if (result.isFailure) return Failure(result.failure);

    return Success(result.success);
  }

  Future<Result<Orders, AppwriteException>> addProduct(
    OrderProducts product,
  ) async {
    final newProducts = <OrderProducts>[...(products), product];
    final result = await copyWith(products: () => newProducts).update(
      context: RelationContext(
        includeId: false,
        children: {'coupons': RelationContext(), 'products': RelationContext()},
      ),
    );
    if (result.isFailure) return Failure(result.failure);

    return Success(result.success);
  }

  Future<Result<Orders, AppwriteException>> deleteProduct(
    OrderProducts product,
  ) async {
    final newProducts = copyWith(
      products: () => products.where((p) => p.$id != product.$id).toList(),
    );

    final order = await copyWith(products: () => newProducts.products).update(
      context: RelationContext(
        includeId: false,
        children: {'coupons': RelationContext(), 'products': RelationContext()},
      ),
    );
    if (order.isFailure) return Failure(order.failure);

    final result = await product.delete();
    if (result.isFailure) return Failure(result.failure);

    return Success(order.success);
  }

  Future<Result<Orders, AppwriteException>> updateProduct(
    OrderProducts product,
  ) async {
    final newProducts =
        products.map((p) {
          if (p.$id == product.$id) return product;
          return p;
        }).toList();

    final result = await copyWith(products: () => newProducts).update(
      context: RelationContext(
        includeId: false,
        children: {'coupons': RelationContext(), 'products': RelationContext()},
      ),
    );
    if (result.isFailure) return Failure(result.failure);

    return Success(result.success);
  }
}

extension CalendarEventsExtensions on CalendarEvents {
  Future<Result<Invoices, AppwriteException>> createInvoice() async {
    final appwrite = di<AppwriteClient>();
    try {
      final invoiceId = await newInvoiceNumber(start);
      if (invoiceId.isFailure) return Failure(invoiceId.failure);
      final user = await appwrite.account.get();

      final permissions = [Permission.read(Role.user(user.$id))];

      final acceptedParticipants =
          participants
              .where(
                (p) => p.status == CalendarEventsParticipantsStatus.accepted,
              )
              .toList();

      log.d('acceptedParticipants: $acceptedParticipants');

      final total =
          amount != null ? amount! * (acceptedParticipants.length) : 0;

      log.d('amount: $total');

      final doc = await appwrite.databases.createDocument(
        databaseId: Invoices.collectionInfo.databaseId,
        collectionId: Invoices.collectionInfo.$id,
        documentId: ID.unique(),
        data: {
          'invoiceNumber': invoiceId.success,
          'date': start.toIso8601String(),
          'name': '$title - attendees: ${acceptedParticipants.length}',
          'amount': total,
          'notes': description,
          'calendarEvent': $id,
        },
        permissions: permissions,
      );

      // Set event permissions to read-only
      await appwrite.databases.updateDocument(
        databaseId: CalendarEvents.collectionInfo.databaseId,
        collectionId: CalendarEvents.collectionInfo.$id,
        documentId: $id,
        permissions: permissions,
      );

      // set participants permissions to read-only
      for (final participant in participants) {
        await appwrite.databases.updateDocument(
          databaseId: CalendarEventsParticipants.collectionInfo.databaseId,
          collectionId: CalendarEventsParticipants.collectionInfo.$id,
          documentId: participant.$id,
          permissions: permissions,
        );
      }

      return Success(Invoices.fromAppwrite(doc));
    } on AppwriteException catch (e) {
      return Failure(e);
    }
  }
}

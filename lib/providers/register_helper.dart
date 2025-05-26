// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:appwrite/appwrite.dart' as _i1;
import 'package:watch_it/watch_it.dart' as _i2;
import 'package:stibu/models/appwrite_client.dart' as _i3;
import 'package:stibu/providers/auth_provider.dart' as _i4;
import 'package:stibu/providers/realtime_subscription.dart' as _i5;
import 'package:stibu/providers/product_keys.dart' as _i6;
import 'package:stibu/providers/products.dart' as _i7;
import 'package:stibu/providers/calendar_events_participants.dart' as _i8;
import 'package:stibu/providers/order_products.dart' as _i9;
import 'package:stibu/providers/expenses.dart' as _i10;
import 'package:stibu/providers/coupons.dart' as _i11;
import 'package:stibu/providers/invoices.dart' as _i12;
import 'package:stibu/providers/custom_products.dart' as _i13;
import 'package:stibu/providers/customers.dart' as _i14;
import 'package:stibu/providers/order_coupons.dart' as _i15;
import 'package:stibu/providers/calendar_events.dart' as _i16;
import 'package:stibu/providers/orders.dart' as _i17;
import 'package:stibu/providers/print_templates.dart' as _i18;

void _registerAppwriteClient(_i1.Client client) {
  _i2.di.registerSingleton<_i3.AppwriteClient>(_i3.AppwriteClient(client));
}

void _registerAuthProvider<T extends _i4.AuthProvider>(T Function() factory) =>
    _i2.di.registerLazySingletonAsync<T>(() async {
      final auth = factory();
      await auth.build();
      return auth;
    });
void _registerRealtimeProvider<T extends _i4.AuthProvider>() =>
    _i2.di.registerLazySingletonAsync<_i5.RealtimeSubscriptions>(() async {
      final realtime = _i2.di<_i3.AppwriteClient>().realtime;
      final subscriptions = _i5.RealtimeSubscriptions<T>(realtime);
      await subscriptions.build();
      return subscriptions;
    });
void _registerProductKeysProvider() =>
    _i2.di.registerLazySingletonAsync<_i6.ProductKeysProvider>(() async {
      final model = _i6.ProductKeysProvider();
      await model.build();
      return model;
    });
void _registerProductsProvider() =>
    _i2.di.registerLazySingletonAsync<_i7.ProductsProvider>(() async {
      final model = _i7.ProductsProvider();
      await model.build();
      return model;
    });
void _registerCalendarEventsParticipantsProvider() =>
    _i2.di.registerLazySingletonAsync<_i8.CalendarEventsParticipantsProvider>(
        () async {
      final model = _i8.CalendarEventsParticipantsProvider();
      await model.build();
      return model;
    });
void _registerOrderProductsProvider() =>
    _i2.di.registerLazySingletonAsync<_i9.OrderProductsProvider>(() async {
      final model = _i9.OrderProductsProvider();
      await model.build();
      return model;
    });
void _registerExpensesProvider() =>
    _i2.di.registerLazySingletonAsync<_i10.ExpensesProvider>(() async {
      final model = _i10.ExpensesProvider();
      await model.build();
      return model;
    });
void _registerCouponsProvider() =>
    _i2.di.registerLazySingletonAsync<_i11.CouponsProvider>(() async {
      final model = _i11.CouponsProvider();
      await model.build();
      return model;
    });
void _registerInvoicesProvider() =>
    _i2.di.registerLazySingletonAsync<_i12.InvoicesProvider>(() async {
      final model = _i12.InvoicesProvider();
      await model.build();
      return model;
    });
void _registerCustomProductsProvider() =>
    _i2.di.registerLazySingletonAsync<_i13.CustomProductsProvider>(() async {
      final model = _i13.CustomProductsProvider();
      await model.build();
      return model;
    });
void _registerCustomersProvider() =>
    _i2.di.registerLazySingletonAsync<_i14.CustomersProvider>(() async {
      final model = _i14.CustomersProvider();
      await model.build();
      return model;
    });
void _registerOrderCouponsProvider() =>
    _i2.di.registerLazySingletonAsync<_i15.OrderCouponsProvider>(() async {
      final model = _i15.OrderCouponsProvider();
      await model.build();
      return model;
    });
void _registerCalendarEventsProvider() =>
    _i2.di.registerLazySingletonAsync<_i16.CalendarEventsProvider>(() async {
      final model = _i16.CalendarEventsProvider();
      await model.build();
      return model;
    });
void _registerOrdersProvider() =>
    _i2.di.registerLazySingletonAsync<_i17.OrdersProvider>(() async {
      final model = _i17.OrdersProvider();
      await model.build();
      return model;
    });
void _registerPrintTemplatesProvider() =>
    _i2.di.registerLazySingletonAsync<_i18.PrintTemplatesProvider>(() async {
      final model = _i18.PrintTemplatesProvider();
      await model.build();
      return model;
    });
void registerServices<T extends _i4.AuthProvider>(
  T Function() factory,
  _i1.Client client,
) {
  _registerAppwriteClient(client);
  _registerAuthProvider<T>(factory);
  _registerRealtimeProvider<T>();
}

void registerProviders() {
  _registerProductKeysProvider();
  _registerProductsProvider();
  _registerCalendarEventsParticipantsProvider();
  _registerOrderProductsProvider();
  _registerExpensesProvider();
  _registerCouponsProvider();
  _registerInvoicesProvider();
  _registerCustomProductsProvider();
  _registerCustomersProvider();
  _registerOrderCouponsProvider();
  _registerCalendarEventsProvider();
  _registerOrdersProvider();
  _registerPrintTemplatesProvider();
}

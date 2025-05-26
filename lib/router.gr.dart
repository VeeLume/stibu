// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;
import 'package:stibu/core/app_scaffold/scaffold.dart' as _i8;
import 'package:stibu/models/customers.dart' as _i12;
import 'package:stibu/models/orders.dart' as _i13;
import 'package:stibu/pages/coupons/list_page.dart' as _i1;
import 'package:stibu/pages/customers/detail_page.dart' as _i2;
import 'package:stibu/pages/customers/list_page.dart' as _i3;
import 'package:stibu/pages/dashboard.dart' as _i4;
import 'package:stibu/pages/login.dart' as _i5;
import 'package:stibu/pages/orders/detail_page.dart' as _i6;
import 'package:stibu/pages/orders/list_page.dart' as _i7;
import 'package:stibu/pages/signup.dart' as _i9;

/// generated route for
/// [_i1.CouponListPage]
class CouponListRoute extends _i10.PageRouteInfo<void> {
  const CouponListRoute({List<_i10.PageRouteInfo>? children})
    : super(CouponListRoute.name, initialChildren: children);

  static const String name = 'CouponListRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i1.CouponListPage();
    },
  );
}

/// generated route for
/// [_i2.CustomerDetailPage]
class CustomerDetailRoute extends _i10.PageRouteInfo<CustomerDetailRouteArgs> {
  CustomerDetailRoute({
    _i11.Key? key,
    required String documentId,
    _i12.Customers? customer,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         CustomerDetailRoute.name,
         args: CustomerDetailRouteArgs(
           key: key,
           documentId: documentId,
           customer: customer,
         ),
         rawPathParams: {'id': documentId},
         initialChildren: children,
       );

  static const String name = 'CustomerDetailRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CustomerDetailRouteArgs>(
        orElse:
            () =>
                CustomerDetailRouteArgs(documentId: pathParams.getString('id')),
      );
      return _i2.CustomerDetailPage(
        key: args.key,
        documentId: args.documentId,
        customer: args.customer,
      );
    },
  );
}

class CustomerDetailRouteArgs {
  const CustomerDetailRouteArgs({
    this.key,
    required this.documentId,
    this.customer,
  });

  final _i11.Key? key;

  final String documentId;

  final _i12.Customers? customer;

  @override
  String toString() {
    return 'CustomerDetailRouteArgs{key: $key, documentId: $documentId, customer: $customer}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CustomerDetailRouteArgs) return false;
    return key == other.key &&
        documentId == other.documentId &&
        customer == other.customer;
  }

  @override
  int get hashCode => key.hashCode ^ documentId.hashCode ^ customer.hashCode;
}

/// generated route for
/// [_i3.CustomerListPage]
class CustomerListRoute extends _i10.PageRouteInfo<void> {
  const CustomerListRoute({List<_i10.PageRouteInfo>? children})
    : super(CustomerListRoute.name, initialChildren: children);

  static const String name = 'CustomerListRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i3.CustomerListPage();
    },
  );
}

/// generated route for
/// [_i4.DashboardPage]
class DashboardRoute extends _i10.PageRouteInfo<void> {
  const DashboardRoute({List<_i10.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i4.DashboardPage();
    },
  );
}

/// generated route for
/// [_i5.LoginPage]
class LoginRoute extends _i10.PageRouteInfo<void> {
  const LoginRoute({List<_i10.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i5.LoginPage();
    },
  );
}

/// generated route for
/// [_i6.OrderDetailPage]
class OrderDetailRoute extends _i10.PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({
    _i11.Key? key,
    required String documentId,
    _i13.Orders? order,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         OrderDetailRoute.name,
         args: OrderDetailRouteArgs(
           key: key,
           documentId: documentId,
           order: order,
         ),
         rawPathParams: {'id': documentId},
         initialChildren: children,
       );

  static const String name = 'OrderDetailRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<OrderDetailRouteArgs>(
        orElse:
            () => OrderDetailRouteArgs(documentId: pathParams.getString('id')),
      );
      return _i6.OrderDetailPage(
        key: args.key,
        documentId: args.documentId,
        order: args.order,
      );
    },
  );
}

class OrderDetailRouteArgs {
  const OrderDetailRouteArgs({this.key, required this.documentId, this.order});

  final _i11.Key? key;

  final String documentId;

  final _i13.Orders? order;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{key: $key, documentId: $documentId, order: $order}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderDetailRouteArgs) return false;
    return key == other.key &&
        documentId == other.documentId &&
        order == other.order;
  }

  @override
  int get hashCode => key.hashCode ^ documentId.hashCode ^ order.hashCode;
}

/// generated route for
/// [_i7.OrderListPage]
class OrderListRoute extends _i10.PageRouteInfo<void> {
  const OrderListRoute({List<_i10.PageRouteInfo>? children})
    : super(OrderListRoute.name, initialChildren: children);

  static const String name = 'OrderListRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i7.OrderListPage();
    },
  );
}

/// generated route for
/// [_i8.ScaffoldRouterPage]
class ScaffoldRouterRoute extends _i10.PageRouteInfo<ScaffoldRouterRouteArgs> {
  ScaffoldRouterRoute({_i11.Key? key, List<_i10.PageRouteInfo>? children})
    : super(
        ScaffoldRouterRoute.name,
        args: ScaffoldRouterRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'ScaffoldRouterRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ScaffoldRouterRouteArgs>(
        orElse: () => const ScaffoldRouterRouteArgs(),
      );
      return _i8.ScaffoldRouterPage(key: args.key);
    },
  );
}

class ScaffoldRouterRouteArgs {
  const ScaffoldRouterRouteArgs({this.key});

  final _i11.Key? key;

  @override
  String toString() {
    return 'ScaffoldRouterRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ScaffoldRouterRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i9.SignupPage]
class SignupRoute extends _i10.PageRouteInfo<void> {
  const SignupRoute({List<_i10.PageRouteInfo>? children})
    : super(SignupRoute.name, initialChildren: children);

  static const String name = 'SignupRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i9.SignupPage();
    },
  );
}

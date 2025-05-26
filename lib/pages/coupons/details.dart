import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/scaffold.dart';
import 'package:stibu/models/coupons.dart';
import 'package:stibu/models/order_coupons.dart';
import 'package:stibu/providers/coupons.dart';
import 'package:watch_it/watch_it.dart';

class CouponDetails extends WatchingWidget {
  final Coupons coupon;
  const CouponDetails({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    final currentCoupon = watchPropertyValue((CouponsProvider c) {
      return c.items.firstWhere(
        (element) => element.$id == coupon.$id,
        orElse: () => coupon,
      );
    });

    final small = smallLayout(context);

    if (small) {
      return Scaffold(
        appBar: AppBar(
          leading: AutoLeadingButton(),
          title: Center(child: Text(currentCoupon.code)),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Code: ${currentCoupon.code}'),
              Text('Remaining credit: ${currentCoupon.remainingValue}'),
              Text('Initial credit: ${currentCoupon.initialValue}'),
              Text('Created at: ${currentCoupon.creationDate}'),
              Text('Last used at: ${currentCoupon.lastChangeDate}'),
              for (final orderCoupon in currentCoupon.orderCoupons)
                OrderCouponDetails(orderCoupon: orderCoupon),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentCoupon.code),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [

          ],
        )),
    );
  }
}

class OrderCouponDetails extends StatelessWidget {
  final OrderCoupons orderCoupon;
  const OrderCouponDetails({super.key, required this.orderCoupon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(orderCoupon.name),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Name: ${orderCoupon.name}'),
            Text('Amount: ${orderCoupon.amount}'),
            Text('Order: ${orderCoupon.order}'),
          ],
        ),
      ),
    );
  }
}

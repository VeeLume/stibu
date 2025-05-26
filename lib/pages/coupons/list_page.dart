import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:stibu/core/app_scaffold/list_page.dart';
import 'package:stibu/core/models_extensions.dart';
import 'package:stibu/models/coupons.dart';
import 'package:stibu/pages/coupons/details.dart';
import 'package:stibu/pages/coupons/input_dialog.dart';
import 'package:stibu/providers/coupons.dart';

@RoutePage()
class CouponListPage extends StatelessWidget {
  const CouponListPage({super.key});

  Widget _addButton(BuildContext context, Function(Coupons)? onItemSelected) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (context) => CouponInputDialog(
                onCouponCreated: (coupon) async {
                  final result = await coupon.create();
                  if (result.isSuccess) {
                    onItemSelected?.call(result.success);
                  } else if (result.isFailure && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.failure.message ?? 'Failed to create coupon.',
                        ),
                      ),
                    );
                  }
                },
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => ListPage<Coupons, CouponsProvider>(
    title: 'Coupons',
    smallLayoutActions:
        (_, onItemSelected) => [_addButton(context, onItemSelected)],
    largeLayoutActions:
        (_, onItemSelected) => [_addButton(context, onItemSelected)],
    listItemBuilder:
        (item, onItemSelected) => ListTile(
          title: Text(item.code),
          subtitle: Text(
            '${item.remainingValue.currency.format()} / ${item.initialValue.currency.format()}',
          ),
          onTap: () => onItemSelected(item),
        ),
    largeLayoutContent: (item, onItemSelected) => CouponDetails(coupon: item),
  );
}

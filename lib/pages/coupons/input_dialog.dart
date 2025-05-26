import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:stibu/core/app_scaffold/dialog.dart';
import 'package:stibu/models/coupons.dart';

class CouponInputDialog extends StatefulWidget {
  final Coupons? coupon;
  final void Function(Coupons) onCouponCreated;

  const CouponInputDialog({
    super.key,
    this.coupon,
    required this.onCouponCreated,
  });

  @override
  State<CouponInputDialog> createState() => _CouponInputDialogState();
}

class _CouponInputDialogState extends State<CouponInputDialog> {
  final _formKey = GlobalKey<FormState>();
  late String? _code = widget.coupon?.code;
  late DateTime creationDate =
      widget.coupon?.creationDate ?? DateTime.now().toUtc();
  late DateTime lastChangeDate =
      widget.coupon?.lastChangeDate ?? DateTime.now().toUtc();
  late int? initialValue = widget.coupon?.initialValue;
  late int? remainingValue = widget.coupon?.remainingValue;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AdaptiveInputDialog(
        content: [_buildFormFields(context)],
        title:
            widget.coupon == null
                ? 'Create Coupon'
                : 'Edit Coupon ${widget.coupon?.code}',
        onSave: () {
          if (_formKey.currentState?.validate() ?? false) {
            _formKey.currentState?.save();
            final coupon =
                widget.coupon != null
                    ? widget.coupon!.copyWith(
                      code: () => _code!,
                      creationDate: () => creationDate,
                      lastChangeDate: () => DateTime.now().toUtc(),
                      initialValue: () => initialValue!,
                      remainingValue: () => remainingValue!,
                    )
                    : Coupons(
                      code:
                          _code ??
                          String.fromCharCodes(
                            List.generate(
                              10,
                              (index) => Random().nextInt(26) + 65,
                            ),
                          ),
                      creationDate: creationDate,
                      lastChangeDate: DateTime.now().toUtc(),
                      initialValue: initialValue ?? 0,
                      remainingValue: remainingValue ?? 0,
                    );
            widget.onCouponCreated(coupon);
            return true;
          }
          return false;
        },
      ),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        Text('Creation Date: ${creationDate.toLocal().format('dd.MM.yyyy')}'),
        Text(
          'Last Change Date: ${lastChangeDate.toLocal().format('dd.MM.yyyy')}',
        ),
        TextFormField(
          readOnly: widget.coupon != null,
          initialValue: _code,
          decoration: const InputDecoration(labelText: 'Code'),
          onSaved: (value) => _code = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a code';
            }
            return null;
          },
        ),
        TextFormField(
          readOnly: widget.coupon != null,
          initialValue: initialValue?.toString(),
          decoration: const InputDecoration(labelText: 'Initial Value'),
          onSaved: (value) => initialValue = int.tryParse(value ?? ''),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an initial value';
            }
            return null;
          },
        ),
        TextFormField(
          initialValue: remainingValue?.toString(),
          decoration: const InputDecoration(labelText: 'Remaining Value'),
          onSaved: (value) => remainingValue = int.tryParse(value ?? ''),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a remaining value';
            }
            return null;
          },
        ),
      ],
    );
  }
}

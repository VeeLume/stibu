import 'dart:async';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:get_it/get_it.dart';
import 'package:product_fix/product.dart';

// This Appwrite function will be executed every time your function is triggered
Future<dynamic> main(final context) async {
  // You can use the Appwrite SDK to interact with other services
  // For this example, we're using the Users service
  final client = Client()
      .setEndpoint(Platform.environment['APPWRITE_FUNCTION_API_ENDPOINT'] ?? '')
      .setProject(Platform.environment['APPWRITE_FUNCTION_PROJECT_ID'] ?? '')
      .setKey(context.req.headers['x-appwrite-key'] ?? '');

  GetIt.I.registerSingleton<AppwriteClient>(AppwriteClient(client));

  final List<Products> recordedProducts = [];

  late int total;

  do {
    final response = await Products.page(
      offset: recordedProducts.isEmpty ? 0 : null,
      last: recordedProducts.isEmpty ? null : recordedProducts.last,
      limit: 250,
    );

    if (response.isFailure) {
      return context.res.json({
        'error': response.failure.message,
      });
    }

    total = response.success.$1;
    recordedProducts.addAll(response.success.$2);
  } while (recordedProducts.length < total);

  context.log('Recorded products: ${recordedProducts.length}');

  int count = 0;
  for (final product in recordedProducts) {
    if (product.inventoryStatus != null && product.inventoryStatus!.isBlank) {
      context.log('Updating product: ${product.id}');
      context.log('Old inventory status: ${product.inventoryStatus}');
      final result = await product
          .copyWith(
            inventoryStatus: () => null,
          )
          .update();

      if (result.isFailure) {
        context.error('Failed to update product: ${product.id}');
        context.error('Error: ${result.failure.message}');
      } else {
        context.log('New inventory status: ${product.inventoryStatus}');
        count++;
      }
    }
  }

  return context.res.json({
    'message': 'Updated $count products',
  });
  // Your code goes here
}

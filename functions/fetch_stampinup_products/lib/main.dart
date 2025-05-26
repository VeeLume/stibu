import 'dart:async';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:get_stampinup_products/products.dart';
import 'package:get_stampinup_products/products_extensions.dart';

// This Appwrite function will be executed every time your function is triggered
Future<dynamic> main(final context) async {
  try {
    // get current products

    final result = await ProductsExtensions.getCurrentProducts();

    final Set<Products> currentProducts = result
        .map((product) {
          if (product.isFailure) {
            context.error('Error Parsing product: ', product.failure.message);
            return null;
          }
          return product.success;
        })
        .whereType<Products>()
        .toSet();

    // initialize Appwrite client
    final client = Client()
        .setEndpoint(
          Platform.environment['APPWRITE_FUNCTION_API_ENDPOINT'] ?? '',
        )
        .setProject(Platform.environment['APPWRITE_FUNCTION_PROJECT_ID'] ?? '')
        .setKey(context.req.headers['x-appwrite-key'] ?? '');
    final databases = Databases(client);

    // get recoded products from database
    // use pagination to get all products
    final recordedProducts = <Products>{};
    int page = 0;
    while (true) {
      final response = await databases.listDocuments(
        databaseId: 'public',
        collectionId: 'products',
        queries: [Query.limit(300), Query.offset(page * 100)],
      );
      if (response.documents.isNotEmpty) {
        recordedProducts.addAll(response.documents.map((document) {
          try {
            return Products.fromAppwrite(document);
          } catch (e) {
            context.error('Error Parsing product: ${e.toString()}');
            context.error('Document: ${document.data}');
            rethrow;
          }
        }));
        page++;
      } else {
        break;
      }
    }

    context.log('Current products: ${currentProducts.length}');
    context.log('Recoded products: ${recordedProducts.length}');
    // find all products that are new or have changed
    final changedProducts = currentProducts.difference(recordedProducts);
    context.log('Changed products: ${changedProducts.length}');

    // add new products to database
    final newProducts = changedProducts.map((product) {
      try {
        return product.toAppwrite(includeId: false);
      } catch (e) {
        context.error('Error Parsing product: ${e.toString()}');
        rethrow;
      }
    }).toList();

    for (final product in newProducts) {
      context.log('New product: $product');
    }

    await databases.createDocuments(
      databaseId: Products.collectionInfo.databaseId,
      collectionId: Products.collectionInfo.$id,
      documents: newProducts,
    );

    return context.res.json({
      "status": "200",
      "newProductsCount": changedProducts.length,
      "newProducts":
          changedProducts.map((product) => product.toJson()).toList(),
    });
  } on Exception catch (e) {
    context.error('Error: ${e.toString()}');
    return context.res.json({"status": "500", 'error': e.toString()});
  }
}

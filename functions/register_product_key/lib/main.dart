import 'dart:async';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';

// This Appwrite function will be executed every time your function is triggered
Future<dynamic> main(final context) async {
  // You can use the Appwrite SDK to interact with other services
  // For this example, we're using the Users service
  final client = Client()
      .setEndpoint(Platform.environment['APPWRITE_FUNCTION_API_ENDPOINT'] ?? '')
      .setProject(Platform.environment['APPWRITE_FUNCTION_PROJECT_ID'] ?? '')
      .setKey(context.req.headers['x-appwrite-key'] ?? '');

  final userId = context.req.headers['x-appwrite-user-id'];
  final productKey = context.req.headers['product-key'];

  if (userId == null || productKey == null) {
    context.log('Missing user ID or product key');
    context.log('User ID: $userId');
    context.log('Product key: $productKey');
    return context.res.json({
      'status': 400,
      'error': 'Missing user ID or product key',
    });
  }

  final database = Databases(client);
  final users = Users(client);

  final response = await database.listDocuments(
    databaseId: 'internal',
    collectionId: 'productKeys',
    queries: [Query.equal('productKey', productKey)],
  );

  context.log('Product key response: ${response.documents.length}');

  if (response.documents.length != 1 ||
      response.documents.first.data['valid'] == false ||
      response.documents.first.data['userId'] != null) {
    context.log('Product key invalid');
    return context.res.json({'status': 403, 'error': 'Product key invalid'});
  }

  final document = response.documents.first;
  final user = await users.get(userId: userId);
  final labels = user.labels.whereType<String>().toList();
  context.log('User labels: $labels');

  if (!labels.contains('validProductKey')) {
    labels.add('validProductKey');
  }

  await users.updateLabels(userId: userId, labels: labels);
  await database.updateDocument(
    databaseId: 'internal',
    collectionId: 'productKeys',
    documentId: document.$id,
    data: {'userId': userId},
  );

  context.log('Product key registered');
  return context.res.json({'status': 200, 'message': 'Product key registered'});
}

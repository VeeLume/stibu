import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_appwrite/dart_appwrite.dart';

// This Appwrite function will be executed every time your function is triggered
Future<dynamic> main(final context) async {
  // You can use the Appwrite SDK to interact with other services
  // For this example, we're using the Users service
  final client = Client()
      .setEndpoint(Platform.environment['APPWRITE_FUNCTION_API_ENDPOINT'] ?? '')
      .setProject(Platform.environment['APPWRITE_FUNCTION_PROJECT_ID'] ?? '')
      .setKey(context.req.headers['x-appwrite-key'] ?? '')
      .setSelfSigned(status: true);

  final database = Databases(client);

  final random = Random.secure();
  final values = List<int>.generate(32, (i) => random.nextInt(256));

  final key = base64UrlEncode(values);

  final response = await database.createDocument(
    databaseId: 'internal',
    collectionId: 'productKeys',
    documentId: ID.unique(),
    data: {'productKey': key, 'isValid': true},
  );

  return context.res.json(response.data);
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';

// This Appwrite function will be executed every time your function is triggered
Future<dynamic> main(final context) async {
  try {
    // 1. Parse JSON request body and save it as data.json
    context.log('Request body: ${context.req.bodyJson}');
    await File('data.json').writeAsString(jsonEncode(context.req.bodyJson));

    // 2. Extract 'id' from query parameters
    final Map<String, dynamic> queryParams = context.req.query;
    final String? id = queryParams['id'];
    if (id == null) {
      context.error('Missing query parameter: id');
      return context.res.text('Missing query parameter: id');
    }

    // You can use the Appwrite SDK to interact with other services
    // For this example, we're using the Users service
    final client = Client()
        .setEndpoint(
            Platform.environment['APPWRITE_FUNCTION_API_ENDPOINT'] ?? '')
        .setProject(Platform.environment['APPWRITE_FUNCTION_PROJECT_ID'] ?? '');

    if (context.req.headers['x-appwrite-user-jwt'] != null) {
      client.setJWT(context.req.headers['x-appwrite-user-jwt']);
    } else {
      context.error(
          "Access denied: This function requires authentication. Please sign in to continue.");
      return context.res.text(
          "Access denied: This function requires authentication. Please sign in to continue.");
    }

    final databases = Databases(client);
    final document = await databases.getDocument(
      databaseId: "672bcb590033b5b2780a",
      collectionId: "67b28bbd0013cd7eff10",
      documentId: id,
    );

    final typstContent = document.data['content'];
    await File('input.typ').writeAsString(typstContent);

    // load typst binary from storage bucket
    // test if file already exists
    if (!await File('typst').exists()) {
      final storage = Storage(client);

      final storageFile = await storage.getFileDownload(
        bucketId: "6736649a002a1b5d7373",
        fileId: '67b36aaf0012cb69abb7',
      );

      await File('typst').writeAsBytes(storageFile);

      // make typst binary executable
      final process = await Process.run('chmod', ['+x', 'typst']);
      if (process.exitCode != 0) {
        throw Exception(
            'Failed to make typst binary executable: ${process.stderr}');
      }
    }

    final dir = Directory.current;
    final files = dir.listSync();
    for (var file in files) {
      context.log('Found file: ${file.path}');
    }

    // 5. Compile Typst file to PDF
    final process = await Process.run(
        File("typst").absolute.path, ['compile', 'input.typ', 'output.pdf']);
    if (process.exitCode != 0) {
      throw Exception('Typst compilation failed: ${process.stderr}');
    }

    // 6. Respond with the generated PDF
    final pdfBytes = await File('output.pdf').readAsBytes();
    return context.res.binary(pdfBytes);
  } catch (error) {
    context.error('Error: $error');
    return context.res.text('Error: $error');
  } finally {
    // delete all files
    if (await File('data.json').exists()) {
      await File('data.json').delete();
    }
    if (await File('input.typ').exists()) {
      await File('input.typ').delete();
    }
    if (await File('output.pdf').exists()) {
      await File('output.pdf').delete();
    }
  }
}

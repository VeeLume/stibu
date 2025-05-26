import 'dart:convert';

import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:product_fix/product.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:http/http.dart' as http;
import 'package:result_type/result_type.dart';

final _unescape = HtmlUnescape();

extension ProductsExtensions on Products {
  static Products fromJson(Map<String, dynamic> json) {
    return Products(
      id: toInt(json['id']),
      itemPrice: toDouble(json['itemPrice']).toInt() * 100,
      qtyLimit: json['qtyLimit'],
      originalItemPrice: toDouble(json['originalItemPrice']).toInt() * 100,
      formattedItemPrice: json['formattedItemPrice'],
      formattedOriginalItemPrice: json['formattedOriginalItemPrice'],
      hasSalePrice: json['hasSalePrice'],
      launchDate: DateTime.parse(json['launchDate']),
      endSaleDate: DateTime.parse(json['endSaleDate']),
      beginSaleDate: DateTime.parse(json['beginSaleDate']),
      slug: json['slug'],
      images: List<String>.unmodifiable(json['images'] ?? []),
      title: json['title'],
      description: _unescape
          .convert(json['description'])
          .replaceAll("<br />", "")
          .replaceAll("<br/>", "\n"),
      inventoryStatus: (json['inventoryStatus'] as String?).nullIfBlank,
      culture: json['culture'],
      color: List<String>.unmodifiable(json['color'] ?? []),
      canBePurchased: json['canBePurchased'],
      exclusiveTo: List<String>.unmodifiable(json['exclusiveTo'] ?? []),
      categorySlugs: List<String>.unmodifiable(json['categorySlugs'] ?? []),
      alternateId: json['alternateId'],
      replacementForItemId: tryToInt(json['replacementForItemId']),
      hoverImage: json['hoverImage'],
      metaDescription: json['metaDescription'],
      metaTitle: json['metaTitle'],
      isCommissionable: json['isCommissionable'],
      excludeFrom: List<String>.unmodifiable(json['excludeFrom'] ?? []),
      languages: List<String>.unmodifiable(json['languages'] ?? []),
      qualifier: List<String>.unmodifiable(json['qualifier'] ?? []),
      lifeCycleStates: List<String>.unmodifiable(json['lifeCycleStates'] ?? []),
      offeringType: json['offeringType'],
    );
  }

  static Future<List<Result<Products, ParseError>>> getCurrentProducts() async {
    final client = http.Client();
    final response = await client.get(
        Uri.https(
          "az-api.stampinup.de",
          "/de-de/products",
          {
            "page": "1",
            "pageSize": "9999",
            "category": "/shop-products",
          },
        ),
        headers: {
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/116.0"
        });

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> products = json['products'];

    final List<Result<Products, ParseError>> result = [];

    for (final product in products) {
      try {
        result.add(Success(fromJson(product)));
      } catch (e) {
        result.add(Failure(ParseError(e.toString())));
      }
    }

    return result;
  }
}

class ParseError implements Exception {
  final String message;

  ParseError(this.message);

  @override
  String toString() => 'ParseError: $message';
}

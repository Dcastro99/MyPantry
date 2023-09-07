import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inventory_app/models/product_seed.dart';

String? baseUrl = dotenv.get('BASE_URL', fallback: 'BASE_URL not found');

class CartData with ChangeNotifier {
  String? baseUrl = dotenv.get('BASE_URL', fallback: 'BASE_URL not found');

  List<dynamic> _productData = [];
  List<dynamic> get productData => _productData;

  Future<List<dynamic>> fetchCartProducts() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return [];
    }

    final authToken = await currentUser.getIdToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final cartUrl = '$baseUrl/cart';

    Map<String, String> queryParams = {
      'user': currentUser.email!,
    };

    Uri uri = Uri.parse(cartUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(Uri.parse('$uri'), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        _productData =
            jsonData.map((json) => ProductSeed.fromJson(json)).toList();
        notifyListeners();
        return _productData;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

//-------------------ADD PRODUCT PROVIDER-------------------//
  addtoCart(ProductSeed newProduct) {
    final existingProductIndex = _productData.indexWhere(
      (product) => product.productName == newProduct.productName.toLowerCase(),
    );

    if (existingProductIndex != -1) {
      final existingProduct = _productData[existingProductIndex];
      final updatedProduct = ProductSeed(
        user: existingProduct.user,
        productName: existingProduct.productName,
        category: existingProduct.category,
        uom: existingProduct.uom,
        id: existingProduct.id,
        qty: existingProduct.qty + newProduct.qty,
        id2: existingProduct.id2,
        checked: existingProduct.checked,
      );

      _productData[existingProductIndex] = updatedProduct;
      print('updating in Provider');
      // sendPutRequest(updatedProduct.toJson());
    } else {
      print('adding in Provider');
      sendPostRequest(newProduct.toJson());
      _productData.add(newProduct);
    }

    notifyListeners();
  }

//-------------------UPDATE PRODUCT PROVIDER-------------------//
  updateProduct(ProductSeed updatedProduct) {
    final productIndex = _productData.indexWhere(
      (product) => product.id == updatedProduct.id,
    );
    if (productIndex != -1) {
      _productData[productIndex] = updatedProduct;
      sendPutRequest(updatedProduct.toJson());
    }
    notifyListeners();
  }

//-------------------REMOVE PRODUCT PROVIDER-------------------//
  removeProduct(String id) {
    _productData.removeWhere((product) => product.id == id);
    sendDeleteRequest(id);
    notifyListeners();
  }
}

//-------------------Post Ticket Data-------------------//

Future<void> sendPostRequest(Map<String, dynamic> productObj) async {
  final Map<String, String> headers = {
    'Content-Type':
        'application/json', // Set the appropriate content type for your API
    // Add any other headers you might need, such as authentication tokens
  };
  final http.Response response = await http.post(
    Uri.parse('$baseUrl/carts'),
    headers: headers,
    body: jsonEncode(productObj),
  );

  if (response.statusCode == 200) {
    // Successful response, handle the data as needed
    // print('Response: ${response.body}');
  } else {
    // Error response, handle the error
    print('Error: ${response.statusCode}');
  }
}

//-------------------Put Product-------------------//

Future<void> sendPutRequest(Map<String, dynamic> productObj) async {
  final id = productObj['id'];
  final Map<String, String> headers = {
    'Content-Type':
        'application/json', // Set the appropriate content type for your API
    // Add any other headers you might need, such as authentication tokens
  };
  final http.Response response = await http.put(
    Uri.parse('$baseUrl/product/$id'),
    headers: headers,
    body: jsonEncode(productObj),
  );

  if (response.statusCode == 200) {
  } else {
    print('Error: ${response.statusCode}');
  }
}

//-------------------Delete Product-------------------//

Future<bool> sendDeleteRequest(String productId) async {
  print('Deleting product with id: $productId');
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  try {
    final http.Response response = await http.delete(
      Uri.parse('$baseUrl/cart/$productId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Successful response, handle the data as needed
      // print('Response: ${response.body}');
      return true; // Return true for success
    } else {
      // Error response, handle the error
      print('Error: ${response.statusCode}');
      return false; // Return false for failure
    }
  } catch (error) {
    print('Error: $error');
    return false; // Return false for failure
  }
}

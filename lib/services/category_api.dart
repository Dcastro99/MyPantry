import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inventory_app/models/category_seed.dart';
import 'package:inventory_app/models/product_seed.dart';

String? baseUrl = dotenv.get('BASE_URL', fallback: 'BASE_URL not found');

class CategoryData with ChangeNotifier {
  String? baseUrl = dotenv.get('BASE_URL', fallback: 'BASE_URL not found');

  List<CategorySeed> _categoryData = [];
  List<CategorySeed> get categoryData => _categoryData;

  Future<List<CategorySeed>> fetchCategories() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return [];
    }

    final authToken = await currentUser.getIdToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final cartUrl = '$baseUrl/categories';

    Map<String, String> queryParams = {
      'user': currentUser.email!,
    };

    Uri uri = Uri.parse(cartUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(Uri.parse('$uri'), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        _categoryData =
            jsonData.map((json) => CategorySeed.fromJson(json)).toList();

        notifyListeners();
        return _categoryData;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  Future<List<String>> fetchCategoryNames() async {
    try {
      final categories = await fetchCategories();
      final categoryNames =
          categories.map((category) => category.category).toList();
      return categoryNames;
    } catch (e) {
      print('Error fetching category names: $e');
      return []; // You can return an empty list or handle the error in another way.
    }
  }

//-------------------ADD PRODUCT PROVIDER-------------------//
  addCategory(CategorySeed newCategory) {
    final existingCategoryIndex = _categoryData.indexWhere(
      (category) => category.id == newCategory.id,
    );

    if (existingCategoryIndex != -1) {
      final existingCategory = _categoryData[existingCategoryIndex];
      final updatedCategory = CategorySeed(
        id: existingCategory.id,
        user: existingCategory.user,
        category: existingCategory.category,
      );

      _categoryData[existingCategoryIndex] = updatedCategory;
      // sendPutRequest(updatedCategory.toJson());
    } else {
      // Map<String, dynamic> categoryObj = {
      //   'user': newCategory.user,
      //   'category': newCategory.category,
      // };
      _categoryData.add(newCategory);
    }

    notifyListeners();
  }

//-------------------UPDATE PRODUCT PROVIDER-------------------//
  // updateProduct(ProductSeed updatedProduct) {
  //   final productIndex = _categoryData.indexWhere(
  //     (product) => product.id == updatedProduct.id,
  //   );
  //   if (productIndex != -1) {
  //     _categoryData[productIndex] = updatedProduct;
  //     sendPutRequest(updatedProduct.toJson());
  //   }
  //   notifyListeners();
  // }

//-------------------REMOVE CATEGORY PROVIDER-------------------//
  removeProduct(String id) {
    _categoryData.removeWhere((category) => category.id == id);
    sendDeleteRequest(id);
    notifyListeners();
  }
}

//-------------------Post category Data-------------------//

Future<void> sendCategoryPostRequest(Map<String, dynamic> categoryObj) async {
  final Map<String, String> headers = {
    'Content-Type':
        'application/json', // Set the appropriate content type for your API
    // Add any other headers you might need, such as authentication tokens
  };
  final http.Response response = await http.post(
    Uri.parse('$baseUrl/categories'),
    headers: headers,
    body: jsonEncode(categoryObj),
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

// Future<void> sendPutRequest(Map<String, dynamic> categoryObj) async {
//   final id = categoryObj['id'];
//   final Map<String, String> headers = {
//     'Content-Type':
//         'application/json', // Set the appropriate content type for your API
//     // Add any other headers you might need, such as authentication tokens
//   };
//   final http.Response response = await http.put(
//     Uri.parse('$baseUrl/categories/$id'),
//     headers: headers,
//     body: jsonEncode(categoryObj),
//   );

//   if (response.statusCode == 200) {
//   } else {
//     print('Error: ${response.statusCode}');
//   }
// }

//-------------------Delete Product-------------------//

Future<bool> sendDeleteRequest(String categoryId) async {
  print('Deleting product with id: $categoryId');
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  try {
    final http.Response response = await http.delete(
      Uri.parse('$baseUrl/categories/$categoryId'),
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

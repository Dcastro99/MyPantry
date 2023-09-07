import 'package:flutter/material.dart';
import 'package:inventory_app/models/product_seed.dart';

class ProductListNotifier extends ValueNotifier<List<ProductSeed>> {
  ProductListNotifier(List<ProductSeed> initialValue) : super(initialValue);

  void updateProductList(List<ProductSeed> newList) {
    value = newList;
  }
}

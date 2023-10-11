import 'package:flutter/material.dart';
import 'package:inventory_app/components/Products/product_display_cards.dart';
import 'package:inventory_app/models/product_seed.dart';
import 'package:inventory_app/providers/value_provider.dart';
import 'package:inventory_app/components/Header/header.dart';
import 'package:inventory_app/services/category_api.dart';
import 'package:inventory_app/services/product_api.dart';
import 'package:inventory_app/providers/search_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController = TextEditingController();
  final productListNotifier = ProductListNotifier([]);
  List<String> categories = [];

  List<ProductSeed> filteredProducts = [];
  String selectedCategory = '';

  void _handleSearch(
      BuildContext context, String query, String selectedCategory) {
    final productData = Provider.of<ProductData>(context, listen: false);
    var products = productData.productData;

    if (selectedCategory.isNotEmpty) {
      products = products
          .where((product) => product.category == selectedCategory)
          .toList();
    }

    productListNotifier.updateProductList(products); // Update product list

    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.setSearchQuery(query); // Update search query
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  void _getCategories() async {
    final categoryData = Provider.of<CategoryData>(context, listen: false);
    final fetchedCategoryNames = await categoryData.fetchCategoryNames();
    setState(() {
      categories = fetchedCategoryNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Header(
          searchController: searchController,
          onSearch: (query, selectedCategory) => _handleSearch(
              context, query, selectedCategory), 
          selectedCategory: selectedCategory, 
          onCategoryChange: (category) {
            setState(() {
              selectedCategory = category;
              filteredProducts
                  .clear(); 
            });
          },
        ),
      ),
      body: Consumer<CategoryData>(
        builder: (context, categoryData, child) {
          List<String> categoryNames = categoryData.categoryData
              .map((category) => category.category)
              .toList();

          return ProductCardDisplay(
            searchController: searchController,
            filteredProducts: filteredProducts,
            onSearch: (query, selectedCategory) =>
                _handleSearch(context, query, selectedCategory),
            categories: categoryNames,
          );
        },
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/components/HelperWidgets/my_delete_button.dart';
import 'package:inventory_app/components/Products/product_delete_dialog.dart';
import 'package:inventory_app/models/product_seed.dart';
import 'package:inventory_app/providers/search_provider.dart';
import 'package:inventory_app/providers/value_provider.dart';
import 'package:inventory_app/services/product_api.dart';
import 'package:provider/provider.dart';

class ProductCardDisplay extends StatefulWidget {
  final Function(String, String) onSearch;
  final TextEditingController searchController;
  final List<ProductSeed> filteredProducts;
  final List<String> categories;

  const ProductCardDisplay(
      {super.key,
      required this.onSearch,
      required this.searchController,
      required this.filteredProducts,
      required this.categories});

  @override
  State<ProductCardDisplay> createState() => _ProductCardDisplayState();
}

class _ProductCardDisplayState extends State<ProductCardDisplay> {
  List<ProductSeed> productData = [];
  String selectedCategory = '';
  List<ProductSeed> products = [];
  final productListNotifier = ProductListNotifier([]);
  final user = FirebaseAuth.instance.currentUser!.email!;

  _showCategoryFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: DropdownButton<String>(
            value: selectedCategory,
            onChanged: (String? newValue) {
              widget.onSearch('', '');
              setState(() {
                selectedCategory = newValue ?? '';

                Navigator.pop(context);
              });
            },
            items: [
              const DropdownMenuItem(
                value: '',
                child: Text('All Categories'),
              ),
              for (var category in widget.categories)
                DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ),
            ],
          ),
        );
      },
    );
  }

  _showDeleteDialog(BuildContext context, id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteProduct(
            handleDeleteFuction: (id) async {
              await Provider.of<ProductData>(context, listen: false)
                  .removeProduct(id);
            },
            id: id,
          );
        });
  }

  bool isUserLoggedIn = false;
  // Replace with your authentication logic
  @override
  void initState() {
    super.initState();

    if (user != null) {
      isUserLoggedIn = true;
      fetchProducts();
    } else {
      isUserLoggedIn = false; // User is not logged in
    }
  }

  Future<void> fetchProducts() async {
    final productData = Provider.of<ProductData>(context, listen: false);

    try {
      final fetchedProducts = await productData.fetchInventoryProducts();
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(96, 121, 132, 135),
      body: ValueListenableBuilder(
          valueListenable: productListNotifier,
          builder: (context, products, child) {
            return Consumer2<ProductData, SearchProvider>(
                builder: (context, productData, searchProvider, child) {
              products = productData.productData;
              final searchQuery = searchProvider.searchQuery.toLowerCase();

              var filteredProducts = List.of(products);

              if (selectedCategory.isNotEmpty) {
                filteredProducts = filteredProducts
                    .where((product) => product.category == selectedCategory)
                    .toList();
              }

              if (searchQuery.isNotEmpty) {
                filteredProducts = filteredProducts
                    .where((product) =>
                        product.productName.toLowerCase().contains(searchQuery))
                    .toList();
              }
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: filteredProducts.map((product) {
                    return Card(
                      elevation: 15,
                      color: Color.fromARGB(255, 230, 228, 228),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              product.productName, // Display product name here
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                product.uom, // Display product category here
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'IndieFlower',
                                  fontWeight: FontWeight.bold,
                                )),
                            trailing: Text(
                              product.qty
                                  .toString(), // Display product quantity here
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // onTap: () {},
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/edit',
                                          arguments: product);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 97, 174, 176)),
                                    ),
                                    child: const Icon(Icons.edit_outlined)),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyDeleteButton(
                                  onPressed: () {
                                    _showDeleteDialog(context, product.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            });
          }),
      floatingActionButton: Align(
        widthFactor: 7.1,
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          onPressed: () {
            _showCategoryFilterDialog(context);
          },
          backgroundColor: Color.fromARGB(93, 255, 255, 255),
          child: const Icon(Icons.filter_alt_outlined,
              color: Color.fromARGB(255, 73, 73, 73)),
        ),
      ),
    );
  }
}

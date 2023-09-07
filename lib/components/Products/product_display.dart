// import 'package:flutter/material.dart';
// import 'package:inventory_app/models/product_seed.dart';
// import 'package:inventory_app/providers/value_provider.dart';
// import 'package:inventory_app/components/Footer/footer.dart';
// import 'package:inventory_app/components/HelperWidgets/my_delete_button.dart';
// import 'package:inventory_app/components/Products/product_delete_dialog.dart';
// import 'package:inventory_app/services/product_api.dart';
// import 'package:inventory_app/providers/search_provider.dart';
// import 'package:provider/provider.dart';

// class ProductDisplay extends StatefulWidget {
//   final Function(String, String) onSearch;
//   final TextEditingController searchController;
//   final List<ProductSeed> filteredProducts;
//   const ProductDisplay(
//       {super.key,
//       required this.searchController,
//       required this.onSearch,
//       required this.filteredProducts});

//   @override
//   State<ProductDisplay> createState() => _ProductDisplayState();
// }

// class _ProductDisplayState extends State<ProductDisplay> {
//   List<ProductSeed> productData = [];
//   String selectedCategory = '';
//   List<ProductSeed> products = [];
//   final productListNotifier = ProductListNotifier([]);

//   _showCategoryFilterDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Category'),
//           content: DropdownButton<String>(
//             value: selectedCategory,
//             onChanged: (String? newValue) {
//               widget.onSearch('', '');
//               setState(() {
//                 selectedCategory = newValue ?? '';

//                 Navigator.pop(context);
//               });
//             },
//             items: const [
//               DropdownMenuItem(
//                 value: '',
//                 child: Text('All Categories'),
//               ),
//               DropdownMenuItem(
//                 value: 'spices',
//                 child: Text('Spices'),
//               ),
//               DropdownMenuItem(
//                 value: 'grains',
//                 child: Text('Grains'),
//               ),
//               DropdownMenuItem(
//                 value: 'canned goods',
//                 child: Text('Canned Goods'),
//               ),
//               DropdownMenuItem(
//                 value: 'sauces',
//                 child: Text('Sauces'),
//               ),
//               DropdownMenuItem(
//                 value: 'dairy',
//                 child: Text('Dairy'),
//               ),
//               // ... Add more categories here
//             ],
//           ),
//         );
//       },
//     );
//   }

//   _showDeleteDialog(BuildContext context, id) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return DeleteProduct(
//             handleDeleteFuction: (id) async {
//               await Provider.of<ProductData>(context, listen: false)
//                   .removeProduct(id);
//             },
//             id: id,
//           );
//         });
//   }

//   @override
//   void initState() {
//     super.initState();
//     final productData = Provider.of<ProductData>(context, listen: false);
//     productData.fetchInventoryProducts().then((fetchedProducts) {
//       setState(() {
//         products = fetchedProducts; // Assign fetchedProducts here
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color.fromARGB(96, 121, 132, 135),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ValueListenableBuilder(
//               valueListenable: productListNotifier,
//               builder: (context, products, child) {
//                 return Consumer2<ProductData, SearchProvider>(
//                     builder: (context, productData, searchProvider, child) {
//                   products = productData.productData;
//                   final searchQuery = searchProvider.searchQuery.toLowerCase();

//                   var filteredProducts = List.of(products);

//                   if (selectedCategory.isNotEmpty) {
//                     filteredProducts = filteredProducts
//                         .where(
//                             (product) => product.category == selectedCategory)
//                         .toList();
//                   }

//                   if (searchQuery.isNotEmpty) {
//                     filteredProducts = filteredProducts
//                         .where((product) => product.productName
//                             .toLowerCase()
//                             .contains(searchQuery))
//                         .toList();
//                   }
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: const Color.fromARGB(121, 237, 237, 237),
//                             border: Border.all(
//                                 color: const Color.fromARGB(146, 97, 97, 97),
//                                 width: 5),
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: DataTable(
//                               columns: const [
//                                 DataColumn(label: Text('Product Name')),
//                                 // DataColumn(label: Text('Category')),
//                                 DataColumn(label: Text('Unit of Measurement')),
//                                 DataColumn(label: Text('Quantity')),
//                                 DataColumn(label: Text('')),
//                                 DataColumn(label: Text('')),
//                               ],
//                               rows: filteredProducts.map((product) {
//                                 return DataRow(cells: [
//                                   DataCell(
//                                       Center(child: Text(product.productName))),
//                                   // DataCell(
//                                   //     Center(child: Text(product.category))),
//                                   DataCell(Center(child: Text(product.uom))),
//                                   DataCell(Center(
//                                       child: Text(product.qty.toString()))),
//                                   DataCell(
//                                     ElevatedButton(
//                                         onPressed: () {
//                                           Navigator.pushNamed(context, '/edit',
//                                               arguments: product);
//                                         },
//                                         style: ButtonStyle(
//                                           backgroundColor:
//                                               MaterialStateProperty.all<Color>(
//                                                   const Color.fromARGB(
//                                                       255, 97, 174, 176)),
//                                         ),
//                                         child: const Icon(Icons.edit_outlined)),
//                                   ),
//                                   DataCell(
//                                     MyDeleteButton(
//                                       onPressed: () {
//                                         _showDeleteDialog(context, product.id);
//                                       },
//                                     ),
//                                   ),
//                                 ]);
//                               }).toList(),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 });
//               }),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             _showCategoryFilterDialog(context);
//           },
//           backgroundColor: const Color.fromARGB(255, 97, 174, 176),
//           child: const Icon(Icons.filter_alt_outlined),
//         ),
//         bottomNavigationBar: const BNav2(categories: [],));
//   }
// }

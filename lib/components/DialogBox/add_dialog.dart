// import 'package:flutter/material.dart';
// import 'package:inventory_app/components/Products/product_form.dart';

// class AddProduct extends StatelessWidget {
//   const AddProduct({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200,
//       //    decoration: BoxDecoration(
//       //   color: Colors.red,
//       //   border: Border.all(color: Colors.black, width: 1),
//       // ),
//       child: Dialog(
//         child: Container(
//             //      decoration: BoxDecoration(
//             //   color: Colors.transparent,
//             //   border: Border.all(color: Colors.black, width: 1),
//             // ),
//             height: 125,
//             child: Column(
//               children: [
//                 ElevatedButton(
//                     style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(
//                             Colors.blueGrey[700]!)),
//                     onPressed: () {},
//                     child: const Icon(Icons.shopping_cart_outlined)),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all<Color>(
//                           const Color.fromARGB(255, 230, 228, 228))),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return const Center(
//                           child: ProductForm(categories: [],),
//                         );
//                       },
//                     );
//                   },
//                   child: Text(
//                     '+ Inventory',
//                     style: TextStyle(color: Colors.blueGrey[700]),
//                   ),
//                 ),
//               ],
//             )),
//       ),
//     );
//   }
// }

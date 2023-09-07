  // if (checkoutData.isNotEmpty)
              //   const Padding(
              //     padding: EdgeInsets.all(8.0),
              //     child: Text(
              //       'Completed List',
              //       style: TextStyle(fontFamily: 'DancingScript', fontSize: 22),
              //     ),
              //   ),
              // if (checkoutData.isNotEmpty)
              //   Expanded(
              //     flex: 1,
              //     child: Container(
              //       color: const Color.fromARGB(255, 231, 230, 230),
              //       child: ListView.separated(
              //         itemCount: checkoutData.length,
              //         separatorBuilder: (context, index) => const Divider(
              //           color: Color.fromARGB(71, 128, 128, 128),
              //           thickness: 1,
              //         ),
              //         itemBuilder: (context, index) {
              //           final checkOutItem = checkoutData[index];
              //           return Column(
              //             children: [
              //               Padding(
              //                 padding: const EdgeInsets.all(12.0),
              //                 child: Row(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceEvenly,
              //                   children: [
              //                     Text(
              //                       checkOutItem.productName,
              //                       style: const TextStyle(
              //                         fontSize: 20,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                     Container(
              //                       padding:
              //                           const EdgeInsets.fromLTRB(14, 6, 14, 6),
              //                       decoration: BoxDecoration(
              //                         color: const Color.fromARGB(
              //                             255, 230, 231, 232),
              //                         border: Border.all(
              //                           color: const Color.fromARGB(
              //                               255, 128, 128, 128),
              //                           width: 4,
              //                         ),
              //                         borderRadius: BorderRadius.circular(5),
              //                       ),
              //                       child: Text(checkOutItem.qty.toString()),
              //                     ),
              //                     ElevatedButton(
              //                       onPressed: () {},
              //                       style: ButtonStyle(
              //                         backgroundColor:
              //                             MaterialStateProperty.all<Color>(
              //                           const Color.fromARGB(
              //                               255, 230, 228, 228),
              //                         ),
              //                       ),
              //                       child: Text(
              //                         '+ Inventory',
              //                         style: TextStyle(
              //                             color: Colors.blueGrey[700]),
              //                       ),
              //                     ),
              //                     MyDeleteButton(
              //                       onPressed: () {
              //                         setState(() {
              //                           checkoutData.remove(checkOutItem);
              //                         });
              //                       },
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               const Divider(
              //                 color: Color.fromARGB(71, 128, 128, 128),
              //                 thickness: 1,
              //               ),
              //             ],
              //           );
              //         },
              //       ),
              //     ),
              //   ),



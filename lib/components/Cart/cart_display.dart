// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:inventory_app/models/product_seed.dart';
import 'package:inventory_app/components/HelperWidgets/my_delete_button.dart';
import 'package:inventory_app/components/Products/product_delete_dialog.dart';
import 'package:inventory_app/services/cart_api.dart';
import 'package:inventory_app/services/product_api.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class CartDisplay extends StatefulWidget {
  const CartDisplay({super.key});

  @override
  State<CartDisplay> createState() => _CartDisplayState();
}

class _CartDisplayState extends State<CartDisplay> {
  final List<ProductSeed> checkoutData = [];
  // var productsInCart;

  _showDeleteDialog(BuildContext context, id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteProduct(
            handleDeleteFuction: (id) async {
              await Provider.of<CartData>(context, listen: false)
                  .removeProduct(id);
            },
            id: id,
          );
        });
  }

  void removeFromCheckout(int index) {
    setState(() {
      checkoutData.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    final cartData = Provider.of<CartData>(context, listen: false);
    cartData.fetchCartProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartData>(context);
    var products = cartData.productData;

    void clearCart() async {
      final productsCopy =
          List.from(products); // Create a copy of the products list
      for (final removedProduct in productsCopy) {
        await Provider.of<CartData>(context, listen: false)
            .removeProduct(removedProduct.id);
      }
      checkoutData.clear();
      for (final product in products) {
        product.checked = false;
      }
      setState(() {});
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(96, 121, 132, 135),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: const Text(
          'Check List',
          style: TextStyle(fontFamily: 'DancingScript', fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              clearCart();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color.fromARGB(255, 97, 174, 176),
          onRefresh: () async {
            await cartData.fetchCartProducts(); // Refresh the cart data
          },
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        // Remove the product from products and checkoutData lists
                        final removedProduct = products.removeAt(index);
                        checkoutData.remove(removedProduct);
                        setState(() {
                          _showDeleteDialog(context, removedProduct.id);
                        });
                      },
                      background: Container(
                        color: const Color.fromARGB(255, 232, 111, 111),
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      child: Card(
                        elevation: 12,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 230, 231, 232),
                            border: Border.all(
                              color: const Color.fromARGB(255, 128, 128, 128),
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      product.productName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      'Quantity: ${product.qty}',
                                    ),
                                  ),
                                ),
                                product.checked
                                    ? const Text('')
                                    : ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color.fromARGB(
                                                      255, 97, 174, 176)),
                                        ),
                                        child: const Icon(Icons.edit),
                                      ),
                                const SizedBox(width: 10),
                                product.checked
                                    ? const Text('')
                                    : MyDeleteButton(onPressed: () {
                                        _showDeleteDialog(context, product.id);
                                      }),

                                //-------------------ADD TO CHECKOUT-------------------//
                                product.checked
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          ;
                                          await Provider.of<ProductData>(
                                                  context,
                                                  listen: false)
                                              .addProduct(product);
                                          await Provider.of<CartData>(context,
                                                  listen: false)
                                              .removeProduct(product.id);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                255, 230, 228, 228),
                                          ),
                                        ),
                                        child: Text(
                                          '+ Inventory',
                                          style: TextStyle(
                                              color: Colors.blueGrey[700]),
                                        ),
                                      )
                                    : const Text(''),
                                const SizedBox(width: 10),
                                TextButton(
                                    style: ButtonStyle(
                                        side: MaterialStateProperty.all<
                                            BorderSide>(
                                      const BorderSide(
                                        color:
                                            Color.fromARGB(255, 128, 128, 128),
                                        width: 2,
                                      ),
                                    )),
                                    onPressed: () {
                                      final product = products[index];
                                      product.checked = !product.checked;
                                      if (product.checked) {
                                        checkoutData.add(product);
                                      } else {
                                        checkoutData.remove(product);
                                      }
                                      setState(() {});
                                    },
                                    child: Icon(
                                        color: product.checked
                                            ? const Color.fromARGB(
                                                255, 25, 193, 112)
                                            : const Color.fromARGB(
                                                255, 230, 231, 232),
                                        Icons.check)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (checkoutData.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 237, 237, 237)),
                      ),
                      onPressed: () {
                        clearCart();
                      },
                      child: const Text('Clear Cart',
                          style: TextStyle(
                              color: Color.fromARGB(255, 232, 111, 111),
                              fontSize: 18)),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 237, 237, 237)),
                      ),
                      onPressed: () async {
                        for (final product in checkoutData) {
                          await Provider.of<ProductData>(context, listen: false)
                              .addProduct(product);
                          await Provider.of<CartData>(context, listen: false)
                              .removeProduct(product.id);
                        }
                        checkoutData.clear();
                        setState(() {});
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Center(child: Text('All done!')),
                              content: const Center(
                                child: Text(
                                    'All items have been added to your inventory.'),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('+ All to Inventory',
                          style: TextStyle(
                              color: Color.fromARGB(255, 121, 121, 121),
                              fontSize: 18)),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

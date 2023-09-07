import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/models/product_seed.dart';
import 'package:inventory_app/services/product_api.dart';
import 'package:provider/provider.dart';

class ProductEdit extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  ProductEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductSeed;
    final uomController = TextEditingController();
    final qtyController = TextEditingController();
     final user = FirebaseAuth.instance.currentUser!.email!;

    // String productName = product.productName;
    print(product.productName);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 208, 212, 214),
      body: Center(
        child: Dialog(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: 400,
            height: 280,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                    child: Column(
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Product Name: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(product.productName,
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Product Category: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(product.category,
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Product Unit of Measure: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(product.uom,
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                    child: Row(
                      children: [
                        const Text('Quantity: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: qtyController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 200, 200, 200)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 79, 200, 192)),
                              ),
                              // contentPadding: EdgeInsets.symmetric(horizontal: 30),
                              hintText: product.qty.toString(),
                              // labelText: 'Quantatiy',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(context, '/home');
                        },
                        child: Text('X',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 45, 46, 46))),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          int? parsedQty = int.tryParse(
                              qtyController.text.isEmpty
                                  ? product.qty.toString()
                                  : qtyController.text);
                          ProductSeed newProduct;

                          if (_formKey.currentState!.validate()) {
                            if (parsedQty != null) {
                              newProduct = ProductSeed(
                                user:user,
                                productName: product.productName,
                                category: product.category,
                                uom: uomController.text.isEmpty
                                    ? product.uom
                                    : uomController.text,
                                id: product.id,
                                qty: parsedQty,
                                id2: product.id2,
                                checked: false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please enter a valid quantity'),
                                ),
                              );
                              return;
                            }

                            await Provider.of<ProductData>(context,
                                    listen: false)
                                .updateProduct(newProduct);

                            if (newProduct.productName.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a product name'),
                                ),
                              );
                            } else {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 229, 229, 229)),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              color: Color.fromARGB(255, 54, 129, 164)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}

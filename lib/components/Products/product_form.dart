import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/components/Products/add_category.dart';
import 'package:inventory_app/models/category_seed.dart';
import 'package:inventory_app/models/product_seed.dart';
import 'package:inventory_app/components/HelperWidgets/my_downdrop.dart';
import 'package:inventory_app/components/HelperWidgets/my_textfeilds.dart';
import 'package:inventory_app/services/cart_api.dart';
import 'package:inventory_app/services/category_api.dart';
import 'package:inventory_app/services/product_api.dart';
import 'package:provider/provider.dart';

class ProductForm extends StatefulWidget {
  
  const ProductForm({super.key});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final uomController = TextEditingController();
  final qtyController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!.email!;
  String dropdownCategoryValue = '';
  String dropdownUomValue = '';
  Set<String> categories = {};
  String addNew = 'add new';
  bool categoriesFetched = false;

  void addCategory(String newCategory) {
    setState(() {
      categories.add(newCategory);
      dropdownCategoryValue = newCategory;
      CategoryData().addCategory(CategorySeed(
        user: user,
        category: newCategory,
        id: '',
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    print(categoriesFetched);
    if (!categoriesFetched) {
      _fetchCategories();
    }
  }

  Future<void> _fetchCategories() async {
    final categoryData = Provider.of<CategoryData>(context, listen: false);
    final fetchedCategoryNames = await categoryData.fetchCategoryNames();
    if(mounted){
      setState(() {
        dropdownCategoryValue = '';
        categories.addAll(fetchedCategoryNames);
        categoriesFetched = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final categoryData = Provider.of<CategoryData>(context);
    final categoryNames =
        categoryData.categoryData.map((category) => category.category).toSet();
    final categoriesList = categoryNames.toList();

    print('categories: $categoryNames');

    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      children: [
        SizedBox(
          width: 400,
          height: 400,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextfeild(
                    controller: productNameController,
                    hintText: 'Product Name',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextfeild(
                    controller: qtyController,
                    hintText: 'Quantity',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Text(
                              'Unit of Measurement',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      MyDropdown(
                          items: const [
                            '',
                            'Can',
                            'Bag',
                            'Ounce',
                            'Bottle',
                            'Box',
                          ],
                          selectedItem: dropdownUomValue,
                          onChanged: (value) {
                            setState(() {
                              dropdownUomValue = value!;
                            });
                          }),
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Text(
                              'Category',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      MyDropdown(
                        items:
                            [dropdownCategoryValue] + categoriesList + [addNew],
                        selectedItem: dropdownCategoryValue,
                        onChanged: (value) {
                          setState(() {
                            if (value == 'add new') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddCategory(
                                      onCategoryAdded: addCategory);
                                },
                              );
                            } else {
                              dropdownCategoryValue = value!;
                            }
                          });
                        },
                        itemStyles: const {
                          'add new': TextStyle(
                            color: Colors.red,
                          ),
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //-------------------------INVENTORY BUTTON-------------------------//
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 230, 228, 228),
                          ),
                        ),
                        onPressed: () async {
                          int? parsedQty = int.tryParse(qtyController.text);
                          ProductSeed newProduct;

                          if (_formKey.currentState!.validate()) {
                            if (parsedQty != null) {
                              newProduct = ProductSeed(
                                user: user,
                                productName: productNameController.text,
                                category: dropdownCategoryValue,
                                uom: dropdownUomValue,
                                id: '',
                                qty: parsedQty,
                                id2: '',
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
                                .addProduct(newProduct);

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
                        child: Text(
                          '+ Inventory',
                          style: TextStyle(color: Colors.blueGrey[700]),
                        ),
                      ),
                      //-------------------------CART BUTTON-------------------------//
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueGrey[700]!)),
                          onPressed: () async {
                            int? parsedQty = int.tryParse(qtyController.text);
                            ProductSeed newProduct;

                            if (_formKey.currentState!.validate()) {
                              if (parsedQty != null) {
                                newProduct = ProductSeed(
                                  user: user,
                                  productName: productNameController.text,
                                  category: dropdownCategoryValue,
                                  uom: dropdownUomValue,
                                  id: '',
                                  qty: parsedQty,
                                  id2: '',
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

                              await Provider.of<CartData>(context,
                                      listen: false)
                                  .addtoCart(newProduct);

                              if (newProduct.productName.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please enter a product name'),
                                  ),
                                );
                              } else {
                                productNameController.clear();
                                qtyController.clear();
                                setState(() {
                                  dropdownCategoryValue = '';
                                  dropdownUomValue = '';
                                });
                              }
                            }
                          },
                          child: const Icon(Icons.add_shopping_cart)),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

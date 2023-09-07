import 'package:flutter/material.dart';
import 'package:inventory_app/components/Cart/cart_display.dart';
import 'package:inventory_app/components/Footer/footer.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CartDisplay(),
      bottomNavigationBar: BNav2(),
    );
  }
}

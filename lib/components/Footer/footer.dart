import 'package:flutter/material.dart';
import 'package:inventory_app/components/DialogBox/add_dialog.dart';
import 'package:inventory_app/components/Products/product_form.dart';
import 'package:inventory_app/components/modals/menu_modal.dart';
import 'package:inventory_app/home.dart';
import 'package:velocity_x/velocity_x.dart';

class BNav2 extends StatelessWidget {
  
  const BNav2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(96, 121, 132, 135)
      ),
      child: RoundedBox(
        child: BottomNavigationBar(
          
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: const [
            BottomNavigationBarItem(
              // backgroundColor: Colors.transparent,
              icon: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                size: 30,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
          ],
          selectedItemColor: Colors.blueGrey[700],
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushNamedAndRemoveUntil(context, '/home' , (route) => false);
            } else if (index == 1) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Center(
                    child: ProductForm(),
                  );
                },
              );
            } else if (index == 2) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Center(
                    child: MenuModal(),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class RoundedBox extends StatelessWidget {
  const RoundedBox({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VxBox(child: child)
        .color(Vx.hexToColor("#ebe5dd"))
        .roundedLg
        .px12
        .make();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/services/product_api.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

// import '../Logout/logout.dart';

class MenuModal extends StatefulWidget {
  const MenuModal({super.key});

  @override
  State<MenuModal> createState() => _MenuModalState();
}

class _MenuModalState extends State<MenuModal> {
  final _userName = FirebaseAuth.instance.currentUser!.email!;

  void logoutOut() async {
    Navigator.pop(context);
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       width: double.infinity,
       height: 600,
      color: Colors.transparent,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(20.0),
            left: Radius.circular(20.0),
          ),
        ),
        backgroundColor: Vx.hexToColor('#faf7f2'),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Vx.hexToColor("#ebe5dd"),
              ),
              child: const Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 10),
            Flexible(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    title: const Center(child: Text('CART')),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Center(child: Text('INVENTORY')),
                    onTap: () {
                                            Navigator.pop(context);

                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    
                    title: const Center(child: Text('NOTES')),
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Center(child: Text('REMINDERS')),
                    onTap: () {},
                  ),
                  // Add more ListTiles as needed for additional options
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 89, 87, 87), // hover background color
                        foregroundColor:
                            Colors.white, // foreground (icon) color
                      ),
                      onPressed: () {
                        logoutOut();
                      },
                      child: const Icon(Icons.logout)),
                  //Logout(),
                  Column(
                    children: [
                      const CircleAvatar(
                        radius: 40.0,
                        backgroundImage: NetworkImage(
                            'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                      ),
                      Text(
                        _userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

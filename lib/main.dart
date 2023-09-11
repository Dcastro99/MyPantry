import 'package:flutter/material.dart';
import 'package:inventory_app/pages/auth_page.dart';
import 'package:inventory_app/pages/cart_page.dart';
import 'package:inventory_app/pages/home_page.dart';
import 'package:inventory_app/pages/login_or_register.dart';
import 'package:inventory_app/providers/value_provider.dart';
import 'package:inventory_app/components/Products/product_edit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inventory_app/services/cart_api.dart';
import 'package:inventory_app/services/category_api.dart';
import 'package:inventory_app/services/product_api.dart';
import 'package:inventory_app/providers/search_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  await dotenv.load();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ProductData()),
      ChangeNotifierProvider(create: (context) => CartData()),
      ChangeNotifierProvider<CategoryData>(create: (context) => CategoryData()),
      ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
      ChangeNotifierProvider<ProductListNotifier>(
        create: (_) => ProductListNotifier([]),
      ),
    ],
    child: MaterialApp(
      initialRoute: '/auth',
      routes: {
        '/home': (context) => const HomePage(),
        '/edit': (context) => ProductEdit(),
        '/cart': (context) => const CartPage(),
        '/login': (context) =>  const LoginOrRegister(),
        '/auth': (context) =>  const Authpage(),
      },
    ),
  ));
  // debugPaintSizeEnabled = true; // Enable visualizing layout constraints
}

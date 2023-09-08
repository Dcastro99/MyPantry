import 'package:flutter/material.dart';
import 'package:inventory_app/components/Footer/footer.dart';
import 'package:inventory_app/home.dart';
import 'package:inventory_app/services/category_api.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Home(
      
      ),
      bottomNavigationBar: BNav2(),
    );
  }
}

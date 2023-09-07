import 'package:flutter/material.dart';

class MyTextfeild extends StatelessWidget {
  final controller;
  final String hintText;
  const MyTextfeild(
      {super.key,
      this.controller,
      required this.hintText,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 200, 200, 200)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 79, 200, 192)),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          
          hintText: hintText,
        ),
        
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyDeleteButton extends StatelessWidget {
  final VoidCallback onPressed;
  const MyDeleteButton({super.key, required this.onPressed});

 
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 232, 111, 111),
        ),
      ),
      child: const Icon(Icons.delete_outlined),
    );
  }
}
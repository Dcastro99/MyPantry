import 'package:flutter/material.dart';

class DeleteProduct extends StatelessWidget {
  final String id;
  final Function handleDeleteFuction;
  const DeleteProduct(
      {Key? key, required this.handleDeleteFuction, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationCurve: Curves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 300,
          height: 150,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Text('Are you sure you want to delete this product?'),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(const Color.fromARGB(255, 48, 48, 48)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateColor.resolveWith(
                            (states) => Color.fromARGB(255, 239, 104, 104)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color.fromARGB(255, 226, 226, 226)),
                      ),
                      onPressed: () {
                        handleDeleteFuction(id);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

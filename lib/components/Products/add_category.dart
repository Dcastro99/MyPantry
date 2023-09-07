import 'package:flutter/material.dart';
import 'package:inventory_app/components/HelperWidgets/my_textfeilds.dart';

class AddCategory extends StatefulWidget {
  final Function(String) onCategoryAdded;
  const AddCategory({super.key, required this.onCategoryAdded});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text('Add Category')),
      children: <Widget>[
        MyTextfeild(controller: categoryController, hintText: 'category name'),
        Center(
          child: SimpleDialogOption(
            onPressed: () {
              final newCategory = categoryController.text;
              if (newCategory.isNotEmpty) {
                widget.onCategoryAdded(newCategory);
              }

              Navigator.of(context).pop();
            },
            
            child: const Card(
                color: Color.fromARGB(255, 97, 174, 176),
                elevation: 8,
                child:  Padding(
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Text('Add'),
                )),
          ),
        ),
      ],
    );
  }
}

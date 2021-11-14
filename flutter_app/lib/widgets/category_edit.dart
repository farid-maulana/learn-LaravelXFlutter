import 'package:flutter/material.dart';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/services/api.dart';

class CategoryEdit extends StatefulWidget {
  final Category category;

  const CategoryEdit(this.category, {Key? key}) : super(key: key);

  @override
  _CategoryEditState createState() => _CategoryEditState();
}

class _CategoryEditState extends State<CategoryEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final categoryNameController = TextEditingController();
  ApiService apiService = ApiService();
  String errorMessage = '';

  @override
  void initState() {
    categoryNameController.text = widget.category.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              onChanged: (text) => setState(() => errorMessage = ''),
              controller: categoryNameController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Enter category name';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Category name',
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => saveCategory(),
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ],
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Future saveCategory() async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    apiService
        .updateCategory(widget.category.id, categoryNameController.text)
        .then((value) => Navigator.pop(context))
        .catchError((exception) {
          setState(() {
            errorMessage = exception.toString();
          });
    });

    // Navigator.pop(context);
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/drawer.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Category",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18),
            color: const Color(0xFF54357E),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil.setWidth(16)),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ScreenUtil.setHeight(20)),
                Text(
                  "Add Your Ingredients Category\nWith Details Here!",
                  style: TextStyle(
                    fontSize: ScreenUtil.setSp(18),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF54357E),
                  ),
                ),
                SizedBox(height: ScreenUtil.setHeight(20)),
                _buildTextField(
                  controller: _nameController,
                  label: "Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ScreenUtil.setHeight(16)),
                _buildTextField(
                  controller: _categoryController,
                  label: "Category",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ScreenUtil.setHeight(30)),
                Button(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle Add button press
                      log("Category Added: ${_nameController.text}, ${_categoryController.text}");
                    }
                  },
                  text: "Add Category",
                  width: double.infinity,
                  leadingIcon: const Icon(Icons.add, size: 20, color: Colors.white),
                ),
                SizedBox(height: ScreenUtil.setHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields with validation
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ScreenUtil.setSp(16),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF54357E),
          ),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_managment/utils/screen_util.dart';
import 'package:stock_managment/services/token_service.dart';
import 'package:stock_managment/views/screens/dashboard/dashboard_screen.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/drawer.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TokenService _tokenService = TokenService(); // Initialize TokenService

  Future<void> _addCategory() async {
    final String apiUrl = 'https://stock.cslancer.com/api/food-categories';
    final token = await _tokenService.getToken();

    if (token == null) {
      log('Token is null. Please log in to continue.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to log in again.')),
      );
      return;
    }

    final Map<String, dynamic> requestBody = {
      "name": _nameController.text,
      "description": _descriptionController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include token in headers
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        log("Category Added: ${_nameController.text}, ${_descriptionController.text}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category added successfully!')),
        );
        _nameController.clear();
        _descriptionController.clear();

        // Navigate back or refresh the page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        log("Failed to add category: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add category: ${response.body}')),
        );
      }
    } catch (e) {
      log('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

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
                      return 'Please enter a Category name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ScreenUtil.setHeight(16)),
                _buildTextField(
                  controller: _descriptionController,
                  label: "Description",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ScreenUtil.setHeight(30)),
                Button(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Call the API to add the category
                      _addCategory();
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
    _descriptionController.dispose();
    super.dispose();
  }
}

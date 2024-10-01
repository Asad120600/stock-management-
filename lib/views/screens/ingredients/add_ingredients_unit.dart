import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/token_service.dart';
import 'package:stock_managment/views/screens/dashboard_screen.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/drawer.dart';

class AddIngredientsUnitScreen extends StatefulWidget {
  const AddIngredientsUnitScreen({super.key});

  @override
  _AddIngredientsUnitScreenState createState() => _AddIngredientsUnitScreenState();
}

class _AddIngredientsUnitScreenState extends State<AddIngredientsUnitScreen> {
  final TextEditingController _unitNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TokenService _tokenService = TokenService(); // Initialize TokenService

  Future<void> _addUnit() async {
    final String apiUrl = 'https://stock.cslancer.com/api/units';

    // Retrieve the token
    final token = await _tokenService.getToken();

    // Log the token to check its value
    log('Retrieved Token: $token');

    // Check if the token is null
    if (token == null) {
      log('Token is null. Please log in to continue.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to log in again.')),
      );
      return; // Exit early if token is null
    }

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      "name": _unitNameController.text,
    };

    try {
      log('Request Headers: ${{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }}');
      log('Request Body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include token in headers
        },
        body: jsonEncode(requestBody),
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body ?? 'No response'}');

      if (response.statusCode == 201) {
        log("Unit Added: ${_unitNameController.text}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unit added successfully!')),
        );
        _unitNameController.clear();

        // Navigate to the Dashboard screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        log("Failed to add unit: ${response.body ?? 'No response'}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add unit: ${response.body ?? 'No response'}')),
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
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Ingredient Unit",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18),
          ),
        ),
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
                  "Add Ingredients Unit Here!",
                  style: TextStyle(
                    fontSize: ScreenUtil.setSp(18),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF54357E),
                  ),
                ),
                SizedBox(height: ScreenUtil.setHeight(20)),
                _buildTextField(label: "Unit Name *", controller: _unitNameController),
                SizedBox(height: ScreenUtil.setHeight(16)),
                Button(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Call the API to add the unit
                      _addUnit();
                    }
                  },
                  text: "Add",
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

  // Helper method to build text fields
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a unit name';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _unitNameController.dispose();
    super.dispose();
  }
}

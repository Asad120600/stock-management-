import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonEncode
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/dots.dart';
import 'package:stock_managment/widgets/drawer.dart';
import 'package:stock_managment/views/screens/dashboard_screen.dart'; // Import DashboardScreen

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  // TextEditingControllers for the input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // State variable to track loading status
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Supplier",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18), // Responsive text size
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.setWidth(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ScreenUtil.setHeight(20)),
              Text(
                "Add Your Supplier Details Here!",
                style: TextStyle(
                  fontSize: ScreenUtil.setSp(18),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF54357E),
                ),
              ),
              SizedBox(height: ScreenUtil.setHeight(20)),
              Form(
                child: Column(
                  children: [
                    // Name field
                    _buildTextField(label: "Name *", controller: nameController),
                    SizedBox(height: ScreenUtil.setHeight(16)),

                    // Contact Person field
                    _buildTextField(label: "Contact Person *", controller: contactController),
                    SizedBox(height: ScreenUtil.setHeight(16)),

                    // Email field
                    _buildTextField(label: "Email", controller: emailController),
                    SizedBox(height: ScreenUtil.setHeight(30)),

                    // Add Supplier Button
                    SizedBox(
                      width: double.infinity,
                      child: isLoading
                          ? const LoadingDots() // Show LoadingDots while loading
                          : Button(
                        onPressed: () {
                          // Handle Add Supplier button press
                          addSupplier(
                            name: nameController.text,
                            contact: contactController.text,
                            email: emailController.text,
                            context: context, // Pass the BuildContext here
                          );
                        },
                        text: "Add Supplier",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields with labels above
  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ScreenUtil.setSp(16),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF54357E), // Label color set to #54357E
          ),
        ),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Future<void> addSupplier({
    required String name,
    required String contact,
    required String email,
    required BuildContext context, // Pass the BuildContext
  }) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://stock.cslancer.com/api/suppliers');

    // Retrieve the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Check if token is available
    if (token == null) {
      print("No token found. Please log in first.");
      setState(() {
        isLoading = false;
      });
      return; // Exit if no token is found
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add the token to the headers
      },
      body: jsonEncode({
        'name': name,
        'contact': contact,
        'email': email,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success handling, e.g., show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Supplier added successfully!')),
      );

      // Navigate to DashboardScreen after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()), // Ensure to import the DashboardScreen
        );
      });
    } else {
      // Error handling, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add supplier: ${response.body}')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    nameController.dispose();
    contactController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

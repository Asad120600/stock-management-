import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/drawer.dart';

class AddSupplierScreen extends StatelessWidget {
  const AddSupplierScreen({super.key});

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
      drawer:const AppDrawer(),
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
                    _buildTextField(label: "Name * "),
                    SizedBox(height: ScreenUtil.setHeight(16)),

                    // Contact Person field
                    _buildTextField(label: "Contact Person *"),
                    SizedBox(height: ScreenUtil.setHeight(16)),

                    // Phone field
                    _buildTextField(label: "Phone *"),
                    SizedBox(height: ScreenUtil.setHeight(16)),

                    // Email field
                    _buildTextField(label: "Email"),
                    SizedBox(height: ScreenUtil.setHeight(16)),

                    // Address field
                    _buildTextField(label: "Address"),
                    SizedBox(height: ScreenUtil.setHeight(16)),

                    // Description field
                    _buildTextField(label: "Description"),
                    SizedBox(height: ScreenUtil.setHeight(30)),

                    // Add Supplier Button
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        onPressed: () {
                          // Handle Add Supplier button press
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
  Widget _buildTextField({required String label}) {
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
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}


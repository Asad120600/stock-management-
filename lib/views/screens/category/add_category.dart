import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/drawer.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

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
            color: const Color(0xFF54357E), // Change title color
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil.setWidth(16)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ScreenUtil.setHeight(20)),
              Text(
                "Add Your Ingredients Category\nWith Details Here!",
                style: TextStyle(
                  fontSize: ScreenUtil.setSp(18),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF54357E), // Change text color
                ),
              ),
              SizedBox(height: ScreenUtil.setHeight(20)),
              _buildTextField(label: "Name"),
              SizedBox(height: ScreenUtil.setHeight(16)),
              _buildTextField(label: "Category"),
              SizedBox(height: ScreenUtil.setHeight(30)),
              Button(
                onPressed: () {
                  // Handle Add button press
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
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ScreenUtil.setSp(16),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF54357E), // Change label color
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}

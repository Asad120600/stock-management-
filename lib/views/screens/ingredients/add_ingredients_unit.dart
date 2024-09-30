import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/drawer.dart';

class AddIngredientsUnitScreen extends StatelessWidget {
  const AddIngredientsUnitScreen({super.key});

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
              _buildTextField(label: "Unit Name *"),
              SizedBox(height: ScreenUtil.setHeight(16)),
              _buildTextField(label: "Description *"),
              SizedBox(height: ScreenUtil.setHeight(30)),
        Button(
          onPressed: () {
            // Handle Add button press
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
            color: const Color(0xFF54357E),
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


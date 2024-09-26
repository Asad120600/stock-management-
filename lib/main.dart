import 'package:flutter/material.dart';
import 'package:stock_managment/views/auth/login_screen.dart';
import 'package:stock_managment/views/screens/add_food_screen.dart';
import 'package:stock_managment/views/screens/category/add_category.dart';
import 'package:stock_managment/views/screens/dashboard_screen.dart';
import 'package:stock_managment/views/screens/ingredients/add_ingredients_unit.dart';
import 'package:stock_managment/views/screens/products_list.dart';
import 'package:stock_managment/views/screens/purchase/add_purchase.dart';
import 'package:stock_managment/views/screens/supplier/add_supplier.dart';
import 'package:stock_managment/views/screens/ingredients/add_ingredients.dart';
import 'package:stock_managment/views/screens/ingredients/list_ingredients.dart';
import 'package:stock_managment/views/screens/category/list_categories.dart';
import 'package:stock_managment/views/screens/purchase/list_purchases.dart';
import 'package:stock_managment/views/screens/supplier/list_suppliers_screen.dart';

import 'views/screens/ingredients/ingredients_unit_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:   DashboardScreen(),
    );
  }
}


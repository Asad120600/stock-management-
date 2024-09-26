import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/views/screens/category/add_category.dart';
import 'package:stock_managment/views/screens/category/list_categories.dart';
import 'package:stock_managment/views/screens/dashboard_screen.dart';
import 'package:stock_managment/views/screens/ingredients/add_ingredients.dart';
import 'package:stock_managment/views/screens/ingredients/add_ingredients_unit.dart';
import 'package:stock_managment/views/screens/ingredients/ingredients_unit_list.dart';
import 'package:stock_managment/views/screens/ingredients/list_ingredients.dart';
import 'package:stock_managment/views/screens/purchase/add_purchase.dart';
import 'package:stock_managment/views/screens/purchase/list_purchases.dart';
import 'package:stock_managment/views/screens/supplier/add_supplier.dart';
import 'package:stock_managment/views/screens/supplier/list_suppliers_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250, // Adjust the width of the drawer
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            child: Text(
              "Menu",
              style: TextStyle(
                fontSize: ScreenUtil.setSp(20), // Shortened font size
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Home Menu Item
          _createDrawerItem(
            icon: Icons.home,
            text: "Home",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen())),
          ),

          // Purchased Expansion Tile
          _createExpansionTile(
            icon: Icons.shopping_cart,
            title: "Purchased",
            children: [
              _createDrawerItem(
                text: "Add Supplier",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddSupplierScreen())),
              ),
              _createDrawerItem(
                text: "List Supplier",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ListSupplierScreen())),
              ),
              _createDrawerItem(
                text: "Add Purchase",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPurchaseScreen())),
              ),
              _createDrawerItem(
                text: "List Purchase",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ListPurchaseScreen())),
              ),
            ],
          ),

          // Items Expansion Tile
          _createExpansionTile(
            icon: Icons.list,
            title: "Items",
            children: [
              _createDrawerItem(
                text: "Add Ingredients",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddIngredientScreen())),
              ),
              _createDrawerItem(
                text: "List Ingredients",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ListIngredientsScreen())),
              ),
              _createDrawerItem(
                text: "Add Category",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCategoryScreen())),
              ),
              _createDrawerItem(
                text: "List Category",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ListCategoriesScreen())),
              ),
              _createDrawerItem(
                text: "Add Ingredient Unit",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddIngredientsUnitScreen())),
              ),
              _createDrawerItem(
                text: "List Ingredient Unit",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ListIngredientsUnitScreen())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({IconData? icon, required String text, GestureTapCallback? onTap}) {
    return ListTile(
      leading: icon != null ? Icon(icon, size: ScreenUtil.setSp(20)) : null, // Shortened icon size
      title: Text(
        text,
        style: TextStyle(fontSize: ScreenUtil.setSp(14)), // Shortened font size
      ),
      onTap: onTap,
    );
  }

  Widget _createExpansionTile({required IconData icon, required String title, required List<Widget> children}) {
    return ExpansionTile(
      leading: Icon(icon, size: ScreenUtil.setSp(20)), // Shortened icon size
      title: Text(
        title,
        style: TextStyle(fontSize: ScreenUtil.setSp(14)), // Shortened font size
      ),
      children: children,
    );
  }
}

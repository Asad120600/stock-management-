import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import Spinkit
import 'package:http/http.dart' as http;
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/token_service.dart';
import 'package:stock_managment/widgets/card.dart';
import 'package:stock_managment/widgets/drawer.dart';

class ListCategoriesScreen extends StatefulWidget {
  const ListCategoriesScreen({super.key});

  @override
  _ListCategoriesScreenState createState() => _ListCategoriesScreenState();
}

class _ListCategoriesScreenState extends State<ListCategoriesScreen> {
  final TokenService _tokenService = TokenService();
  List<Map<String, dynamic>> _categories = [];
  String _searchQuery = "";
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final String apiUrl = 'https://stock.cslancer.com/api/food-categories';
    final token = await _tokenService.getToken();

    if (token == null) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          _categories = List<Map<String, dynamic>>.from(
            responseBody.map((category) => {
              'id': category['id'].toString(),
              'name': category['name'],
              'description': category['description'],
            }),
          );
          _isLoading = false; // Set loading to false after data is fetched
        });
      } else {
        print('Failed to fetch categories: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> _deleteCategory(String categoryId) async {
    final String apiUrl = 'https://stock.cslancer.com/api/food-categories/$categoryId';
    final token = await _tokenService.getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token is null. Please log in to continue.')),
      );
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category deleted successfully')),
        );
        _fetchCategories(); // Refresh the categories list
      } else {
        print('Failed to delete category: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete category: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error deleting category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting category: $e')),
      );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true; // Show loading indicator while refreshing
    });
    await _fetchCategories(); // Fetch categories again
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    // Filtered list of categories based on search query
    List<Map<String, dynamic>> filteredCategories = _categories
        .where((category) => category['name']!
        .toString()
        .toLowerCase()
        .contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Categories",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil.setWidth(16)),
        child: Column(
          children: [
            // Refresh Indicator
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData, // Call refresh function on pull down
                child: _isLoading
                    ? Center(
                  child: SpinKitFadingCircle(
                    color: Colors.blue,
                    size: 50.0,
                  ), // Show spinner while loading
                )
                    : ListView.builder(
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    return CommonListItem(
                      title: "Category Name: ${filteredCategories[index]['name']}",
                      subtitle1: "Description: ${filteredCategories[index]['description']}",
                      onEdit: () {
                        print('Edit tapped for ${filteredCategories[index]['name']}');
                        // Add your edit logic here
                      },
                      onDelete: () {
                        String categoryId = filteredCategories[index]['id'].toString();
                        _deleteCategory(categoryId);
                      },
                      index: index,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

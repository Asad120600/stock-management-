import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_managment/utils/screen_util.dart';
import 'package:stock_managment/services/token_service.dart';
import 'package:stock_managment/views/auth/login_screen.dart';
import 'package:stock_managment/views/screens/dashboard/items_detail_page.dart';
import 'package:stock_managment/widgets/dots.dart';
import 'package:stock_managment/widgets/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {
  final TokenService _tokenService = TokenService();
  String? userName;
  DateTime? _startDate;
  DateTime? _endDate;
  int totalSuppliers = 0; // Total suppliers count
  String totalAmountSpent = " "; // Total amount spent
  int totalItems = 0; // Total items count
  bool _isLoading = false;
  List<Map<String, dynamic>> _ingredients = [];
  Map<String, dynamic> _report = {
    'ingredients_report': [],
    'financial_report': {}
  };


  //Function to fetch ingredients with authentication
  Future<void> _fetchIngredients() async {
    try {
      // Create an instance of TokenService
      final tokenService = TokenService();

      // Fetch the token from the instance
      String? token = await tokenService.getToken();  // Instance access

      // Making the authenticated request
      final response = await http.get(
        Uri.parse('https://stock.cslancer.com/api/ingredients'),
        headers: {
          'Authorization': 'Bearer $token', // Add token in the Authorization header
          'Content-Type': 'application/json', // Optional, specify content type if needed
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _ingredients = List<Map<String, dynamic>>.from(data);
        });
      } else {
        log('Failed to load ingredients. Status code: ${response.statusCode}');
        log('Response: ${response.body}');
      }
    } catch (error) {
      log('Error fetching ingredients: $error');
    }
  }

// Function to get the ingredient name by ID
  String _getIngredientName(int ingredientId) {
    final ingredient = _ingredients.firstWhere(
          (element) => element['id'] == ingredientId,
      orElse: () => {'name': 'Unknown'},
    );
    return ingredient['name'];
  }

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchDashboardData();  // Make sure this is executed
    _fetchReport();
    _fetchIngredients();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // You can now use _showSnackBar safely here if needed
  }
  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  // Update the _fetchReport method to parse your JSON response structure
  Future<void> _fetchReport() async {
    if (_startDate == null || _endDate == null) {
      // _showSnackBar('Please select both start and end dates.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? token = await _tokenService.getToken();
      String fromDate = DateFormat('yyyy-MM-dd').format(_startDate!);
      String toDate = DateFormat('yyyy-MM-dd').format(_endDate!);

      final response = await http.get(
        Uri.parse('https://stock.cslancer.com/api/dashboard/report?from=$fromDate&to=$toDate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = response.body;
        if (body.isNotEmpty) {
          final data = json.decode(body);
          log('Parsed Data: $data');

          // Check if data is a Map and contains the expected keys
          if (data is Map<String, dynamic> && data.containsKey('ingredients_report') && data.containsKey('financial_report')) {
            setState(() {
              _report = data; // Set report data directly as it is already a Map
            });
          } else {
            _showSnackBar("No data found or unexpected format.");
          }
        }
      } else {
        _showSnackBar("Failed to fetch report. Error: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching report: $e");
      _showSnackBar("Error fetching report: $e");
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }
  Future<void> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email'); // Get the email
    if (email != null && email.isNotEmpty) {
      setState(() {
        userName = email.split('@')[0]; // Example: extracting username from email
      });
    } else {
      setState(() {
        userName = 'User'; // Fallback name if email is null or empty
      });
    }
  }
  // fetch dashboard data
  Future<void> fetchDashboardData() async {
    try {
      String? token = await _tokenService.getToken(); // Fetch token
      final response = await http.get(
        Uri.parse('https://stock.cslancer.com/api/dashboard'),
        headers: {
          'Authorization': 'Bearer $token', // Add Authorization header
        },
      );

      log("Dashboard Data Response: ${response.body}"); // Log the response for debugging

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalItems = data['total_items'] ?? 0; // Total items
          totalSuppliers = data['total_suppliers'] ?? 0; // Total suppliers
          totalAmountSpent = data['total_purchases']?.toString() ?? "0"; // Total amount spent
        });
      } else {
        log("Failed to load dashboard data: ${response.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
    }
  }
  Future<void> _logout() async {
    // Show confirmation dialog
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User chose not to logout
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed logout
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    // If the user confirmed logout
    if (shouldLogout == true) {
      await _tokenService.removeToken(); // Remove the token
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()), // Navigate to login screen
      );
    }
  }

  // snack bar
  void _showSnackBar(String message) {
    // Use the build method context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }
// on get report pressed
  void _onGetReportPressed() {
    if (_startDate == null || _endDate == null) {
      _showSnackBar('Please select both start and end dates.');
    } else {
      _fetchReport(); // Call the fetchReport method only if dates are selected
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(24),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          // Eclipse background
          Positioned(
            top: -200,
            left: -150,
            right: -150,
            child: Container(
              width: MediaQuery.of(context).size.width + 400,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.blue.withOpacity(0.1), Colors.blue],
                  center: const Alignment(-0.3, -0.3),
                  radius: 1.5,
                ),
              ),
            ),
          ),
          // Main content
          RefreshIndicator(
            onRefresh: () async {
              await fetchDashboardData(); // Ensure this is an async method that fetches data
              return; // Return to complete the Future
            },
            child: ListView(
              padding: EdgeInsets.all(ScreenUtil.setWidth(16.0)), // Adding padding around the content
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: ScreenUtil.setSp(22),
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'Hi, ${userName ?? 'User'}',
                  style: TextStyle(
                    fontSize: ScreenUtil.setSp(18),
                    color: Colors.black45,
                  ),
                ),
                SizedBox(height: ScreenUtil.setHeight(30)),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: 'Total Items',
                            value: totalItems.toString(),
                            icon: Icons.shopping_bag,
                            color: Colors.purple,
                          ),
                        ),
                        SizedBox(width: ScreenUtil.setWidth(15)),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: 'Total Suppliers',
                            value: totalSuppliers.toString(),
                            icon: Icons.person,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil.setHeight(30)),
                    _buildAmountSpentCard(),
                    SizedBox(height: ScreenUtil.setHeight(30)),
                    _buildReportSection(),
                    SizedBox(height: ScreenUtil.setHeight(30)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
// Update the _buildReportSection method to display your parsed JSON data
  Widget _buildReportSection() {
    final ingredientsReport = _report['ingredients_report'] ?? [];
    final financialReport = _report['financial_report'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get Report',
          style: TextStyle(fontSize: ScreenUtil.setSp(18), fontWeight: FontWeight.w600),
        ),
        SizedBox(height: ScreenUtil.setHeight(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDateField(
              context: context,
              hintText: _startDate == null
                  ? 'Start Date'
                  : DateFormat('dd/MM/yyyy').format(_startDate!),
              isStartDate: true,
            ),
            _buildDateField(
              context: context,
              hintText: _endDate == null
                  ? 'End Date'
                  : DateFormat('dd/MM/yyyy').format(_endDate!),
              isStartDate: false,
            ),
          ],
        ),
        SizedBox(height: ScreenUtil.setHeight(10)),
        Center(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _onGetReportPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil.setWidth(15)),
              ),
            ),
            child: _isLoading
                ? const LoadingDots(color: Colors.purple)
                : const Text('Get Report', style: TextStyle(color: Colors.white)),
          ),
        ),
        // Display the financial report date range if it exists
        if (financialReport.isNotEmpty) ...[
          SizedBox(height: ScreenUtil.setHeight(10)),
          Center(
            child: Text(
              'Financial Report\nFrom ${DateFormat('dd/MM/yyyy').format(_startDate!)} To ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil.setSp(18)),
            ),
          ),
          SizedBox(height: ScreenUtil.setHeight(10)),
          _buildFinancialReport(financialReport),
        ],
        // Ensure the report section is displayed only if there is data
        if (ingredientsReport.isNotEmpty) ...[
          SizedBox(height: ScreenUtil.setHeight(10)),
          Center(
            child: Text(
              'Stock Report\nFrom ${DateFormat('dd/MM/yyyy').format(_startDate!)} To ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil.setSp(18)),
            ),
          ),
          SizedBox(height: ScreenUtil.setHeight(10)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ingredientsReport.length,
            itemBuilder: (context, index) {
              final item = ingredientsReport[index];
              String ingredientName = _getIngredientName(item['ingredient_id']);
              int ingredientId = item['ingredient_id']; // Get the ingredient ID

              // Ensure that these values are accessed safely
              String totalQuantity = item['total_quantity']?.toString() ?? 'N/A';
              String totalConsumed = item['total_consumed']?.toString() ?? 'N/A';
              String totalRemaining = item['total_remaining']?.toString() ?? 'N/A';

              return Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil.setHeight(8)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ScreenUtil.setWidth(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: ScreenUtil.setWidth(5),
                        offset: Offset(0, ScreenUtil.setHeight(5)),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil.setWidth(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ingredient: $ingredientName',
                              style: TextStyle(fontSize: ScreenUtil.setSp(16), fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                              onPressed: () {
                                // Pass the ingredient ID to the ItemDetailsPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemDetailsPage(ingredientId: ingredientId), // Use ingredient ID here
                                  ),
                                );
                              },
                              child: const Text(
                                'View',
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        _buildReportRow('Total Quantity', totalQuantity),
                        _buildReportRow('Total Consumed', totalConsumed),
                        _buildReportRow('Total Remaining', totalRemaining),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

// Build the financial report section
  Widget _buildFinancialReport(Map<String, dynamic> financialReport) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: ScreenUtil.setWidth(5),
            offset: Offset(0, ScreenUtil.setHeight(5)),
          ),
        ],
      ),
      padding: EdgeInsets.all(ScreenUtil.setWidth(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Report',
            style: TextStyle(fontSize: ScreenUtil.setSp(16), fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ScreenUtil.setHeight(8)), // Add spacing between title and rows
          _buildReportRow('Total Sale', financialReport['total_sale'].toString()),
          _buildReportRow('Total Purchase', financialReport['total_purchase'].toString()),
          _buildReportRow('Total Profit', financialReport['total_profit'].toString()),
          _buildReportRow(
            'Profit Percentage',
            '${financialReport['total_profit_percentage'].toStringAsFixed(2)}%', // Correctly formatted
            isRed: financialReport['total_profit_percentage'] < 0,
          ),
        ],
      ),
    );
  }

// Reusable report row for displaying title-value pairs
  Widget _buildReportRow(String title, String value, {bool isRed = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil.setHeight(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: ScreenUtil.setSp(14), color: Colors.black),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ScreenUtil.setSp(14),
              color: isRed ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

// Date field widget
  Widget _buildDateField({
    required BuildContext context,
    required String hintText,
    required bool isStartDate,
  }) {
    return InkWell(
      onTap: () {
        _selectDate(context, isStartDate: isStartDate);
      },
      child: Container(
        width: ScreenUtil.setWidth(160),
        padding: EdgeInsets.symmetric(vertical: ScreenUtil.setHeight(12)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil.setWidth(10)),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Text(
            hintText,
            style: TextStyle(
              color: Colors.black54,
              fontSize: ScreenUtil.setSp(16),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildStatCard(BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 160,  // Fixed width
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),  // Soft rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 3),  // Shadow position
          ),
        ],
      ),
      child: Row(  // Align title, value, and icon in a row
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(icon, color: Colors.white, size: 32),
        ],
      ),
    );
  }

  // Builds the Amount Spent Card
  Widget _buildAmountSpentCard() {
    return Container(
      width: double.infinity, // Full width card
      padding: const EdgeInsets.all(10), // Consistent padding
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(12), // Smooth rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 3), // Shadow effect
          ),
        ],
      ),
      child: Row( // Row to align text and icon horizontally
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column( // Column for title and amount
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Amount Spent On Purchases',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16, // Reduced text size
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                totalAmountSpent.toString().replaceAll(RegExp(r'(\.0+|\.[1-9]*0+)$'), ''), // Removes trailing zeros
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24, // Adjusted for better visual balance
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Icon(Icons.attach_money, color: Colors.white, size: 32), // Icon on the right
        ],
      ),
    );
  }
}

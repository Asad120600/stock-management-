import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/token_service.dart';
import 'package:stock_managment/views/auth/login_screen.dart';
import 'package:stock_managment/views/screens/items_detail_page.dart';
import 'package:stock_managment/widgets/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For json decoding

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
  List<dynamic> _ingredients = [];
  int totalSuppliers = 0; // Total suppliers count
  String totalAmountSpent = " "; // Total amount spent
  int totalItems = 0; // Total items count
  bool _isLoading = false;
  List<dynamic>? _reportData;

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchDashboardData();
    _fetchReport();
    _fetchPurchases();
  }
 // fetch reports



  Future<void> _fetchReport() async {
    if (_startDate == null || _endDate == null) {
      _showSnackBar('Please select both start and end dates.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _tokenService.getToken();

      if (token == null) {
        _showSnackBar('Access token is not available.');
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://stock.cslancer.com/api/dashboard/report?from=${DateFormat('yyyy-MM-dd').format(_startDate!)}&to=${DateFormat('yyyy-MM-dd').format(_endDate!)}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> report = json.decode(response.body);

        if (report['status'] == 'success') {
          print(report); // Print the report data to see its structure
          setState(() {
            _reportData = report['purchases'].map((purchase) {
              return {
                'id': purchase['id'],
                'ingredient': purchase['ingredient'], // Keep as is for debugging
                'supplier': purchase['supplier']['name'],
                'unit': purchase['unit']['name'],
                'quantity': purchase['quantity'],
                'price': purchase['price'],
                'expiration_date': purchase['expiration_date'],
              };
            }).toList();
          });
        } else {
          throw Exception('No data found for the selected dates.');
        }

    } else {
        throw Exception('Failed to load report: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error loading report: ${e.toString()}');
      _showSnackBar('Error loading report: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildReportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Get Report', style: TextStyle(fontSize: ScreenUtil.setSp(18), fontWeight: FontWeight.w600)),
        SizedBox(height: ScreenUtil.setHeight(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDateField(
              context: context,
              hintText: _startDate == null ? 'Start Date' : DateFormat('dd/MM/yyyy').format(_startDate!),
              isStartDate: true,
            ),
            _buildDateField(
              context: context,
              hintText: _endDate == null ? 'End Date' : DateFormat('dd/MM/yyyy').format(_endDate!),
              isStartDate: false,
            ),
          ],
        ),
        SizedBox(height: ScreenUtil.setHeight(10)),
        ElevatedButton(
          onPressed: _isLoading ? null : _fetchReport,
          child: _isLoading ? CircularProgressIndicator() : Text('Get Report'),
        ),
        if (_reportData != null) ...[
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
            physics: NeverScrollableScrollPhysics(),
            itemCount: _reportData!.length,
            itemBuilder: (context, index) {
              final item = _reportData![index];
              final ingredient = item['ingredient'];
              final supplier = item['supplier'];
              final unit = item['unit'];
              return ListTile(
                title: Text(
                  ingredient is String
                      ? ingredient
                      : (ingredient['name'] ?? 'Unknown Ingredient'),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quantity: ${item['quantity']?.toString() ?? 'N/A'} ${unit is Map ? unit['name'] ?? '' : (unit?.toString() ?? '')}'),
                    Text('Supplier: ${supplier is Map ? supplier['name'] ?? 'Unknown Supplier' : supplier?.toString()}'),
                    Text('Expiration Date: ${item['expiration_date'] ?? 'N/A'}'),
                  ],
                ),
                trailing: Text('${item['price']}'),
              );
            },
          ),
          ElevatedButton(
            onPressed: _downloadReportAsPdf,
            child: Text('Download Report'),
          ),
        ],
      ],
    );
  }

  void _downloadReportAsPdf() async {
    final pdf = pw.Document();

    // Load the custom font
    final fontData = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    // Prepare report items
    final reportItems = _reportData!.map((item) {
      // Access ingredient, supplier, and unit safely
      final ingredient = item['ingredient'] ?? {};
      final supplier = item['supplier'] ?? {};
      final unit = item['unit'] ?? {};

      return pw.Container(
        margin: const pw.EdgeInsets.symmetric(vertical: 5),
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 0.5),
          borderRadius: pw.BorderRadius.circular(5),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Ingredient: ${ingredient is Map ? (ingredient['name'] ?? 'Unknown Ingredient') : 'Unknown Ingredient'}',
              style: pw.TextStyle(font: ttf),
            ),
            pw.Text(
              'Quantity: ${item['quantity'] ?? 'N/A'} ${unit is Map ? unit['name'] ?? '' : ''}',
              style: pw.TextStyle(font: ttf),
            ),
            pw.Text(
              'Supplier: ${supplier is Map ? (supplier['name'] ?? 'Unknown Supplier') : 'Unknown Supplier'}',
              style: pw.TextStyle(font: ttf),
            ),
            pw.Text(
              'Price: \$${item['price'] ?? 'N/A'}',
              style: pw.TextStyle(font: ttf),
            ),
            pw.Text(
              'Expiration Date: ${item['expiration_date'] ?? 'N/A'}',
              style: pw.TextStyle(font: ttf),
            ),
          ],
        ),
      );
    }).toList();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'Stock Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'From ${DateFormat('dd/MM/yyyy').format(_startDate!)} To ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                style: pw.TextStyle(fontSize: 18, font: ttf),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 20),
              // Using Column instead of ListView
              pw.Column(
                children: reportItems,
              ),
            ],
          );
        },
      ),
    );

    // Generate and display the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // select date
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

  Future<void> _fetchPurchases() async {
    try {
      String? token = await TokenService().getToken(); // Fetch token from your TokenService

      var response = await http.get(
        Uri.parse('http://stock.cslancer.com/api/purchases'),
        headers: {
          'Authorization': 'Bearer $token', // Add the Authorization header
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _ingredients = json.decode(response.body);
        });
      } else {
        // Handle error response
        log("Failed to load purchases: ${response.statusCode}");
        log("Response body: ${response.body}");
      }
    } catch (e) {
      // Handle any errors
      log("Error: $e");
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

  Future<void> fetchDashboardData() async {
    try {
      String? token = await _tokenService.getToken(); // Fetch token
      final response = await http.get(
        Uri.parse('https://stock.cslancer.com/api/dashboard'),
        headers: {
          'Authorization': 'Bearer $token', // Add Authorization header
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalItems = data['total_items'] ?? 0; // Total items
          totalSuppliers = data['total_suppliers'] ?? 0; // Total suppliers
          totalAmountSpent = data['total_purchases'] ?? 0.0; // Total amount spent
        });
      } else {
        log("Failed to load dashboard data: ${response.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  Future<void> fetchTotalSuppliers() async {
    final url = Uri.parse('http://stock.cslancer.com/api/suppliers');

    // Retrieve the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      log("No token found. Please log in first.");
      return; // Exit if no token is found
    }

    // Make the GET request to the suppliers API
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add the token to the headers
      },
    );

    if (response.statusCode == 200) {
      // Parse the response body as JSON
      final List<dynamic> suppliers = json.decode(response.body);
      setState(() {
        totalSuppliers = suppliers.length; // Update totalSuppliers with the length of the list
      });
    } else {
      // Handle error response
      log('Failed to load suppliers: ${response.statusCode}');
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

  // snackbar
  void _showSnackBar(String message) {
    // Ensure to use the context from the build method
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil with the current context to get screen dimensions
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: TextStyle(
              fontSize: ScreenUtil.setSp(24),
              fontWeight: FontWeight.bold // Responsive text size
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
      body: RefreshIndicator(
        onRefresh: ()async{
      await fetchDashboardData();
      await _fetchPurchases();
      },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil.setWidth(16.0)), // Adding padding around the content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Hi, ${userName ?? 'User'}', // Dynamic user name display
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
                        icon: Icons.list,
                        color: Colors.purple,
                      ),
                    ),
                     SizedBox(width: ScreenUtil.setWidth(15)), // Add gap here (adjust width as needed)
                    Expanded(
                      child: _buildStatCard(
                        context,
                        title: 'Total Suppliers',
                        value: totalSuppliers.toString(),
                        icon: Icons.business,
                        color: Colors.purple,
                    ),
                    )],
                ),
                SizedBox(height: ScreenUtil.setHeight(30)),
                _buildAmountSpentCard(),
                SizedBox(height: ScreenUtil.setHeight(30)),
                _buildReportSection(),
                SizedBox(height: ScreenUtil.setHeight(30)),
                _buildListItemsSection(),
              ],
            ),
          ]
            ),
        ),
            ),
      )
    );
  }

  Widget _buildStatCard(BuildContext context, {required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      width: ScreenUtil.setWidth(160),
      padding: EdgeInsets.all(ScreenUtil.setWidth(16)),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(0, ScreenUtil.setHeight(6)),
            blurRadius: ScreenUtil.setHeight(6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: ScreenUtil.setSp(32)),
          SizedBox(height: ScreenUtil.setHeight(10)),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.setSp(18),
            ),
          ),
          SizedBox(height: ScreenUtil.setHeight(8)),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.setSp(22),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

// Builds the Amount Spent Card
  Widget _buildAmountSpentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtil.setWidth(16)),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(0, ScreenUtil.setHeight(6)),
            blurRadius: ScreenUtil.setHeight(6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Total Amount Spent On Purchases',
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.setSp(18),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ScreenUtil.setHeight(10)),
          Text(
            totalAmountSpent.toString().replaceAll(RegExp(r'(\.0+|\.[1-9]*0+)$'), ''), // Remove trailing zeros
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.setSp(32),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

// Builds the List Items Section
  Widget _buildListItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil.setWidth(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(0, ScreenUtil.setHeight(6)),
                blurRadius: ScreenUtil.setHeight(6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header with background color
              Container(
                padding: EdgeInsets.all(ScreenUtil.setWidth(16)),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100, // Purple background for header
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(ScreenUtil.setWidth(16)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'List Purchases',
                      style: TextStyle(
                        fontSize: ScreenUtil.setSp(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
              // List of Items - dynamically generated based on API response
              if (_ingredients.isEmpty)
                Padding(
                  padding: EdgeInsets.all(ScreenUtil.setWidth(16)),
                  child: Text(
                    'No purchases available',
                    style: TextStyle(
                      fontSize: ScreenUtil.setSp(14),
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                Column(
                  children: _ingredients.map((purchase) {
                    return Column(
                      children: [
                        _buildListItem(item: purchase),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
        SizedBox(height: ScreenUtil.setHeight(25)), // Added space at the bottom
      ],
    );
  }

  Widget _buildListItem({required Map<String, dynamic> item}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsPage(item: item),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil.setWidth(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item['ingredient'] ?? 'Unknown Ingredient',
              style: TextStyle(
                fontSize: ScreenUtil.setSp(16),
                fontWeight: FontWeight.w600,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Quantity: ${item['quantity'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: ScreenUtil.setSp(14),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Supplier: ${item['supplier'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: ScreenUtil.setSp(14),
                    color: Colors.orange,
                  ),
                ),
                Text(
                  'Price: ${item['price'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: ScreenUtil.setSp(14),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //
  // void _showItemDetailsDialog(
  //     BuildContext context,
  //     String title,
  //     String total,
  //     String supplier,
  //     String amount,
  //     ) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Details for $title',
  //           style: const TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         content: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 16.0),
  //           child: SingleChildScrollView(
  //             child: ListBody(
  //               children: [
  //                 _buildDetailRow('Total:', total),
  //                 _buildDetailRow('Supplier:', supplier),
  //                 _buildDetailRow('Amount:', amount),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Close'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //  }
  //
  // Widget _buildDetailRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           label,
  //           style: const TextStyle(fontWeight: FontWeight.w600),
  //         ),
  //         Text(value),
  //       ],
  //     ),
  //   );
  // }
}
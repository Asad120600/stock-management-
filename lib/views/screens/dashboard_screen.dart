import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  // Function to show Date Picker
  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
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
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
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
                'Hi, Choudary Aoun',
                style: TextStyle(
                  fontSize: ScreenUtil.setSp(18),
                  color: Colors.black45,
                ),
              ),
              SizedBox(height: ScreenUtil.setHeight(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(
                    context,
                    title: 'Total Items',
                    value: '20',
                    icon: Icons.shopping_bag_outlined,
                    color: Colors.purple,
                  ),
                  _buildStatCard(
                    context,
                    title: 'Total Supplier',
                    value: '50',
                    icon: Icons.people_outline,
                    color: Colors.purple,
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil.setHeight(20)),
              _buildAmountSpentCard(),
              SizedBox(height: ScreenUtil.setHeight(30)),
              _buildReportSection(),
              SizedBox(height: ScreenUtil.setHeight(30)),
              _buildListItemsSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the Stat Card Widget
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
            'Total Amount Spend On Purchases',
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.setSp(18),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ScreenUtil.setHeight(10)),
          Text(
            '90',
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

  // Builds the Report Section with Date Fields
  Widget _buildReportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get Report',
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18),
            fontWeight: FontWeight.w600,
          ),
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
        SizedBox(height: ScreenUtil.setHeight(15)),
        SizedBox(
          width: double.infinity,
          height: ScreenUtil.setHeight(50),
          child: ElevatedButton(
            onPressed: () {
              // Get report logic
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: Text(
              'Get Report',
              style: TextStyle(
                  fontSize: ScreenUtil.setSp(20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Builds Date Field Widget
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

  // Builds the List Items Section
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
                      'List Items ', // Changed to "Item"
                      style: TextStyle(
                        fontSize: ScreenUtil.setSp(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),

                  ],
                ),
              ),
              // List of Items
              _buildListItem(
                title: 'Chicken',
                total: '100Kg',
                consumed: '30Kg',
                remaining: '70Kg',
                supplier: 'Supplier A',
                amount: '\$200',
              ),
              const Divider(),
              _buildListItem(
                title: 'Rice',
                total: '500Kg',
                consumed: '200Kg',
                remaining: '300Kg',
                supplier: 'Supplier B',
                amount: '\$150',
              ),
              const Divider(),
              _buildListItem(
                title: 'Potatoes',
                total: '250Kg',
                consumed: '100Kg',
                remaining: '150Kg',
                supplier: 'Supplier C',
                amount: '\$75',
              ),
              const Divider(),
            ],
          ),
        ),
        SizedBox(height: ScreenUtil.setHeight(25)), // Added space at the bottom
      ],
    );
  }

  // Builds a Single List Item Row with dynamic stock information
  Widget _buildListItem({
    required String title,
    required String total,
    required String consumed,
    required String remaining,
    required String supplier, // Added supplier parameter
    required String amount, // Added amount parameter
  }) {
    return InkWell(
      onTap: () {
        _showItemDetailsDialog(context, title, total, consumed, remaining, supplier, amount);
      },
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil.setWidth(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ScreenUtil.setSp(16),
                fontWeight: FontWeight.w600,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total: $total',
                  style: TextStyle(
                    fontSize: ScreenUtil.setSp(14),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Consumed: $consumed',
                  style: TextStyle(
                    fontSize: ScreenUtil.setSp(14),
                    color: Colors.orange,
                  ),
                ),
                Text(
                  'Remaining: $remaining',
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

  // Method to show item details dialog
  void _showItemDetailsDialog(BuildContext context, String title, String total, String consumed, String remaining, String supplier, String amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Details for $title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Total: $total'),
                Text('Consumed: $consumed'),
                Text('Remaining: $remaining'),
                Text('Supplier: $supplier'), // New supplier detail
                Text('Amount: $amount'), // New amount detail
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

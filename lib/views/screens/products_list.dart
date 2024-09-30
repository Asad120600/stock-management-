import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/drawer.dart';
import 'package:stock_managment/widgets/popup_menu.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // List of products with their status
  final List<Map<String, String>> allProducts = [
    {"name": "Newerpoint", "details": "Blue-Small", "status": "active"},
    {"name": "Orangemonkey", "details": "Blue-Small", "status": "sold"},
    {"name": "DIY Craft", "details": "Blue-Small", "status": "active"},
    {"name": "Giftana 4", "details": "Blue-Small", "status": "sold"},
    {"name": "Odessy Pro", "details": "Blue-Small", "status": "active"},
    {"name": "KetC Max", "details": "Blue-Small", "status": "sold"},
    {"name": "Homedics Sound", "details": "Blue-Small", "status": "active"},
    {"name": "Ketsicart", "details": "Blue-Small", "status": "active"},
  ];

  // Variable to store the selected filter (all, active, sold)
  String selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context);

    // Filter products based on the selected filter
    List<Map<String, String>> filteredProducts = allProducts.where((product) {
      if (selectedFilter == 'all') return true;
      return product["status"] == selectedFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product List",
          style: TextStyle(
            fontSize: ScreenUtil.setSp(18),
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: ScreenUtil.setHeight(60),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(ScreenUtil.setWidth(16.0)),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.purple),
                hintText: "Search",
                contentPadding: EdgeInsets.symmetric(
                  vertical: ScreenUtil.setHeight(12),
                  horizontal: ScreenUtil.setWidth(16),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil.setWidth(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil.setWidth(12)),
                  borderSide: const BorderSide(color: Colors.purple),
                ),
              ),
            ),
          ),

          // Filter buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil.setWidth(16.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // "All" button
                FilterButton(
                  label: 'All',
                  isSelected: selectedFilter == 'all',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'all';
                    });
                  },
                ),
                SizedBox(width: ScreenUtil.setWidth(8)),

                // "Active" button
                FilterButton(
                  label: 'Active',
                  isSelected: selectedFilter == 'active',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'active';
                    });
                  },
                ),
                SizedBox(width: ScreenUtil.setWidth(8)),

                // "Sold" button
                FilterButton(
                  label: 'Sold',
                  isSelected: selectedFilter == 'sold',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'sold';
                    });
                  },
                ),
              ],
            ),
          ),

          // Table header with vertical lines
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil.setWidth(16), vertical: ScreenUtil.setHeight(8)),
            child: Container(
              color: Colors.purple,
              padding: EdgeInsets.symmetric(vertical: ScreenUtil.setHeight(8)),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Sr#',
                        style: TextStyle(
                          fontSize: ScreenUtil.setSp(14),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Vertical divider after Sr#
                  Container(
                    width: 1,
                    height: ScreenUtil.setHeight(25),
                    color: Colors.white,
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Text(
                        'Products',
                        style: TextStyle(
                          fontSize: ScreenUtil.setSp(14),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Vertical divider after Products
                  Container(
                    width: 1,
                    height: ScreenUtil.setHeight(25),
                    color: Colors.white,
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Action',
                        style: TextStyle(
                          fontSize: ScreenUtil.setSp(14),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product list
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductItem(
                  srNo: (index + 1).toString(),
                  name: filteredProducts[index]["name"]!,
                  details: filteredProducts[index]["details"]!,
                  onEdit: () {
                    // Handle edit action
                    print("Edit tapped for ${filteredProducts[index]["name"]}");
                  },
                  onDelete: () {
                    // Handle delete action
                    print("Delete tapped for ${filteredProducts[index]["name"]}");
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.purple : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenUtil.setWidth(18.0)),
        ),
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtil.setHeight(8),
          horizontal: ScreenUtil.setWidth(20),
        ),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(fontSize: ScreenUtil.setSp(14)),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String srNo;
  final String name;
  final String details;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductItem({
    super.key,
    required this.srNo,
    required this.name,
    required this.details,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil.setWidth(16.0),
        vertical: ScreenUtil.setHeight(4),
      ),
      child: Card(
        elevation: 1,
        child: Row(
          children: [
            // Sr#
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  srNo,
                  style: TextStyle(fontSize: ScreenUtil.setSp(16)),
                ),
              ),
            ),
            // Vertical divider after Sr#
            Container(
              width: 1,
              height: ScreenUtil.setHeight(40),
              color: Colors.grey[300],
            ),
            // Products name and details
            Expanded(
              flex: 4,
              child: ListTile(
                title: Text(
                  name,
                  style: TextStyle(fontSize: ScreenUtil.setSp(16)),
                ),
                subtitle: Text(
                  details,
                  style: TextStyle(fontSize: ScreenUtil.setSp(14)),
                ),
              ),
            ),
            // Vertical divider after Products
            Container(
              width: 1,
              height: ScreenUtil.setHeight(40),
              color: Colors.grey[300],
            ),
            // Action button (PopupMenuWidget)
            Expanded(
              flex: 1,
              child: PopupMenuWidget(
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

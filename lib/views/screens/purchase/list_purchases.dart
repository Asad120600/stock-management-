import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/drawer.dart';
import 'package:stock_managment/widgets/popup_menu.dart';

class ListPurchaseScreen extends StatefulWidget {
  const ListPurchaseScreen({super.key});

  @override
  _ListPurchaseScreenState createState() => _ListPurchaseScreenState();
}

class _ListPurchaseScreenState extends State<ListPurchaseScreen> {
  TextEditingController searchController = TextEditingController();

  // Sample data for purchases
  List<Map<String, dynamic>> purchases = List.generate(2, (index) {
    return {
      'Supplier': 'Quick Ingredients',
      'Unit': 'Kg',
      'Quantity': 20,
    };
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'List Purchase',
          style: TextStyle(
            fontSize: ScreenUtil.setSp(22),
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil.setWidth(16)),
            child: IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil.setWidth(16)),
        child: Column(
          children: [
            // Search Bar
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil.setWidth(20)),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(16)),

            // List of purchases
            Expanded(
              child: ListView.builder(
                itemCount: purchases.length,
                itemBuilder: (context, index) {
                  final purchase = purchases[index];

                  // Alternate between light grey and light purple
                  final backgroundColor = index % 2 == 0
                      ? Colors.grey[200] // Light grey
                      : Colors.purple[100]; // Light purple

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: ScreenUtil.setHeight(8)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(ScreenUtil.setWidth(12)),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(ScreenUtil.setWidth(16)),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Supplier Text
                            Text(
                              'Supplier: ${purchase['Supplier']}',
                              style: TextStyle(
                                fontSize: ScreenUtil.setSp(16),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF54357E), // Set color here
                              ),
                            ),
                            SizedBox(height: ScreenUtil.setHeight(4)),
                            // Unit Text
                            Text(
                              'Unit: ${purchase['Unit']}',
                              style: TextStyle(
                                fontSize: ScreenUtil.setSp(14),
                                fontWeight: FontWeight.w600, // Adjust weight as needed
                                color: const Color(0xFF54357E), // Set color here
                              ),
                            ),
                            SizedBox(height: ScreenUtil.setHeight(4)),
                            // Quantity Text
                            Text(
                              'Quantity: ${purchase['Quantity']}',
                              style: TextStyle(
                                fontSize: ScreenUtil.setSp(14),
                                fontWeight: FontWeight.w600, // Adjust weight as needed
                                color: const Color(0xFF54357E), // Set color here
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuWidget(
                          onEdit: () {
                            print('Edit tapped for ');
                            // Add your edit logic here
                          },
                          onDelete: () {
                            setState(() {
                            });
                            print('Delete tapped for ');
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/drawer.dart';

class ListSupplierScreen extends StatefulWidget {
  const ListSupplierScreen({super.key});

  @override
  _ListSupplierScreenState createState() => _ListSupplierScreenState();
}

class _ListSupplierScreenState extends State<ListSupplierScreen> {
  TextEditingController searchController = TextEditingController();

  // Sample data for suppliers
  List<Map<String, dynamic>> suppliers = List.generate(3, (index) {
    return {
      'Name': 'Quick Ingredients Supplier',
      'Email': 'kfc@gmail.com',
      'Address': 'M.Town',
    };
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'List Supplier',
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

            // List of suppliers
            Expanded(
              child: ListView.builder(
                itemCount: suppliers.length,
                itemBuilder: (context, index) {
                  final supplier = suppliers[index];

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
                            // Name Text
                            Row(
                              children: [
                                Text(
                                  'Name: ',
                                  style: TextStyle(
                                    fontSize: ScreenUtil.setSp(14),
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF54357E),
                                  ),
                                ),
                                Text(
                                  supplier['Name'],
                                  style: TextStyle(
                                    fontSize: ScreenUtil.setSp(14),
                                    color: const Color(0xFF54357E),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ScreenUtil.setHeight(4)),
                            // Email Text
                            Row(
                              children: [
                                Text(
                                  'Email: ',
                                  style: TextStyle(
                                    fontSize: ScreenUtil.setSp(14),
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF54357E),
                                  ),
                                ),
                                Text(
                                  supplier['Email'],
                                  style: TextStyle(
                                    fontSize: ScreenUtil.setSp(14),
                                    color: const Color(0xFF54357E),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ScreenUtil.setHeight(4)),
                            // Address Text
                            Row(
                              children: [
                                Text(
                                  'Address: ',
                                  style: TextStyle(
                                    fontSize: ScreenUtil.setSp(14),
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF54357E),
                                  ),
                                ),
                                Text(
                                  supplier['Address'],
                                  style: TextStyle(
                                    fontSize: ScreenUtil.setSp(14),
                                    color: const Color(0xFF54357E),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            // Handle more options press
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

import 'package:flutter/material.dart';
import 'package:stock_managment/screen_util.dart';
import 'package:stock_managment/widgets/button.dart';
import 'package:stock_managment/widgets/drawer.dart';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen({super.key});

  @override
  _AddPurchaseScreenState createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  DateTime selectedDate = DateTime.now();
  bool purchasedExpanded = false;
  bool itemsExpanded = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        centerTitle: true,

        title: Text(
          'Add Purchase',
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
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil.setWidth(16)),
        child: ListView(
          children: [
            Text(
              'Add Your Purchase With Details Here!',
              style: TextStyle(
                fontSize: ScreenUtil.setSp(20),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF54357E),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: ScreenUtil.setHeight(16)),

            // Name field
            Text(
              'Name:',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: ScreenUtil.setSp(22),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF54357E),
                height: 1.36, // line-height
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(8)),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(16)),

            // Supplier field
            Text(
              'Supplier:',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: ScreenUtil.setSp(22),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF54357E),
                height: 1.36, // line-height
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(8)),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(16)),

            // Unit of measurement
            Text(
              'Unit of Measurement:',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: ScreenUtil.setSp(22),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF54357E),
                height: 1.36, // line-height
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(8)),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(16)),

            // Quantity field
            Text(
              'Quantity:',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: ScreenUtil.setSp(22),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF54357E),
                height: 1.36, // line-height
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(8)),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(16)),

            // Purchase Price field
            Text(
              'Purchase Price:',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: ScreenUtil.setSp(22),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF54357E),
                height: 1.36, // line-height
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(8)),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(16)),

            // Expiration Date picker
            Text(
              'Expiration Date:',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: ScreenUtil.setSp(22),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF54357E),
                height: 1.36, // line-height
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(8)),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: "${selectedDate.toLocal()}".split(' ')[0],
                  ),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil.setHeight(32)),

            // Add Purchase Button
            Button(onPressed: () {}, text: 'Add Purchase')
          ],
        ),
      ),
    );
  }
}

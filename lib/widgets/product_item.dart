import 'package:flutter/material.dart';
import 'package:stock_managment/utils/screen_util.dart';
import 'package:stock_managment/widgets/popup_menu.dart';

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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

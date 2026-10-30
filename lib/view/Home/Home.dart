import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../Orders/Orders.dart';
import '../Products/Products.dart';
import '../Profile/Profile.dart';
import '../Sale/Sales.dart';
class Hom extends StatefulWidget {
  Hom({
    super.key,
  });

  @override
  State<Hom> createState() => _HomState();
}

class _HomState extends State<Hom> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeViewmodel>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          "Home Page",
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>Profi(),
                ),
              );
            },
            icon: Icon(
              Icons.person,
            ),
          ),
        ],
      ),
      body: provider.loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Dashboard",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: "Products",
                    value: provider.productCount.toString(),
                    icon: Icons.inventory_2,
                    iconColor: Colors.blue,
                    backgroundColor: Colors.blue.shade50,
                  ),
                ),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: _buildMetricCard(
                    title: "Today's Sale",
                    value: "₹${provider.todaySales.toStringAsFixed(2)}",
                    icon: Icons.currency_rupee,
                    iconColor: Colors.orange,
                    backgroundColor: Colors.orange.shade50,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: "Bills",
                    value: provider.billCount.toString(),
                    icon: Icons.receipt_long,
                    iconColor: Colors.green,
                    backgroundColor: Colors.green.shade50,
                  ),
                ),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: _buildMetricCard(
                    title: "Low Stock",
                    value: provider.lowStock.toString(),
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.red,
                    backgroundColor: Colors.red.shade50,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 28,
            ),
            Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    label: "New Sale",
                    icon: Icons.shopping_cart,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Sale(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: _buildActionTile(
                    label: "Products",
                    icon: Icons.inventory,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Proda(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: _buildActionTile(
                    label: "Orders",
                    icon: Icons.local_shipping,
                    color: Colors.deepPurpleAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Online_orders(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 28,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "New Orders",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (provider.newOrders.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Online_orders(),
                        ),
                      );
                    },
                    child: Text("View All"),
                  ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: provider.orderLoading
                  ? Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : provider.newOrders.isEmpty
                  ? Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    "No New Orders",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              )
                  : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: provider.newOrders.length > 2
                    ? 2
                    : provider.newOrders.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1),
                itemBuilder: (context, index) {
                  final snap = provider.newOrders[index];
                  var data = snap.data();
                  List items = data['items'] is List
                      ? data['items']
                      : [];

                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Online_orders(),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade50,
                      child: Icon(
                        Icons.receipt,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(
                      data['orderNo']?.toString() ?? "",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${items.length} items | ${data['status']?.toString() ?? ''}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    trailing: Text(
                      "₹${data['totalAmount']?.toString() ?? '0'}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      height: 135,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iconColor.withOpacity(0.15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        height: 75,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/orderdetail_viewmodel.dart';

class Acceptt extends StatefulWidget {
  final String orderId;

  Acceptt({
    super.key,
    required this.orderId,
  });

  @override
  State<Acceptt> createState() => _AccepttState();
}

class _AccepttState extends State<Acceptt> {
  String _formatDate(dynamic dateField) {
    if (dateField is Timestamp) {
      DateTime dt = dateField.toDate();
      String day = dt.day.toString().padLeft(2, '0');
      String month = dt.month.toString().padLeft(2, '0');
      int hour = dt.hour;
      String period = hour >= 12 ? "PM" : "AM";
      if (hour > 12) {
        hour -= 12;
      } else if (hour == 0) {
        hour = 12;
      }
      String minute = dt.minute.toString().padLeft(2, '0');
      return "$day/$month/${dt.year} • $hour:$minute $period";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderdetailViewmodel(
        orderId: widget.orderId,
      ),
      child: Consumer<OrderdetailViewmodel>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                title: Text("Accepted Order Details"),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          var data = provider.orderData;
          var items = provider.items;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              title: Text("Accepted Order Details"),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue.shade50,
                            child: Icon(
                              Icons.receipt_long,
                              color: Colors.blue,
                              size: 26,
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['orderNo']?.toString() ?? "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _formatDate(data['date']),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.green.shade300,
                              ),
                            ),
                            child: Text(
                              data['status']?.toString() ?? "Accepted",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.blue.shade50,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                  size: 22,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['customerName']?.toString() ??
                                          "Customer",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      data['customerPhone']?.toString() ??
                                          "No phone provided",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if ((data['customerPhone']?.toString() ?? '')
                                  .isNotEmpty)
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                  ),
                                ),
                            ],
                          ),
                          if ((data['address']?.toString() ?? '').isNotEmpty) ...[
                            Divider(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                  color: Colors.grey.shade700,
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    data['address']?.toString() ?? "",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    "Ordered Items (${items.length})",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        var item = items[index];
                        double itemTotal = provider.getItemTotal(item);

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blue.shade50,
                            child: Icon(
                              Icons.inventory_2,
                              size: 20,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            item['pname']?.toString() ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            "${item['qty']} × ₹${item['price']}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          trailing: Text(
                            "₹${itemTotal.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 14),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Subtotal"),
                          trailing: Text(
                            "₹${data['itemsTotal']?.toString() ?? '0'}",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Divider(height: 1),
                        ListTile(
                          title: Text("Delivery Charge"),
                          trailing: Text(
                            "₹${data['deliveryCharge']?.toString() ?? '0'}",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Divider(height: 1),
                        ListTile(
                          title: Text(
                            "Total Amount",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Text(
                            "₹${data['totalAmount']?.toString() ?? '0'}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await provider.makeReady(context);
                      },
                      icon: Icon(Icons.check_circle_outline),
                      label: Text(
                        "Mark as Ready",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/order_viewmodel.dart';
import '../Orders/Vieworder.dart';

class Neworder extends StatefulWidget {
  Neworder({
    super.key,
  });

  @override
  State<Neworder> createState() => _NeworderState();
}

class _NeworderState extends State<Neworder> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<OrderViewmodel>(
      context,
    );

    var docs = provider.newOrders;

    return Scaffold(
      body: provider.loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : docs.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 12),
            Text(
              "No New Orders",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final snap = docs[index];
          var data = snap.data();
          List items = data['items'] is List ? data['items'] : [];

          return Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(
                          Icons.inventory_2,
                          color: Colors.blue,
                          size: 26,
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['orderNo']?.toString() ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              data['customerName']?.toString() ??
                                  "Customer",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "${items.length} items",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹${data['totalAmount']?.toString() ?? '0'}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green.shade800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.orange.shade300,
                              ),
                            ),
                            child: Text(
                              "New",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Orderdetails(
                                  orderId: snap.id,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding:
                            EdgeInsets.symmetric(vertical: 11),
                          ),
                          child: Text(
                            "View Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await provider.updateStatus(
                              snap.id,
                              "Accepted",
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding:
                            EdgeInsets.symmetric(vertical: 11),
                          ),
                          child: Text(
                            "Accept",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
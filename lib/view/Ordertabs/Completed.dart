import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/order_viewmodel.dart';
import '../Orders/Complee.dart';


class Completee extends StatefulWidget {
  Completee({
    super.key,
  });

  @override
  State<Completee> createState() => _CompleteeState();
}

class _CompleteeState extends State<Completee> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<OrderViewmodel>(
      context,
    );

    var docs = provider.completedOrders;

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
              Icons.task_alt_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 12),
            Text(
              "No Completed Orders",
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
                        backgroundColor: Colors.green.shade50,
                        child: Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
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
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.green.shade300,
                              ),
                            ),
                            child: Text(
                              data['status']?.toString() ?? "Completed",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Complee(
                              orderId: snap.id,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.visibility_outlined,
                        size: 18,
                      ),
                      label: Text(
                        "View Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
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
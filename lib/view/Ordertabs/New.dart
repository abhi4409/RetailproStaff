import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/order_viewmodel.dart';
import '../Orders/Vieworder.dart';

class Neworders extends StatefulWidget {
  const Neworders({
    super.key,
  });

  @override
  State<Neworders> createState() => _NewordersState();
}

class _NewordersState extends State<Neworders> {
  double getDouble(dynamic value) {
    return double.tryParse(
      value?.toString() ?? '0',
    ) ??
        0.0;
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<OrderViewmodel>(
      context,
    );

    if (provider.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.newOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 70,
              color: Colors.grey.shade400,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "No New Orders",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: provider.newOrders.length,
      itemBuilder: (
          context,
          index,
          ) {
        final snap =
        provider.newOrders[index];

        final data =
        snap.data();

        final List items =
        data['items'] is List
            ? data['items']
            : [];

        String orderNo =
            data['orderNo']
                ?.toString() ??
                "";

        String customerName =
            data['customerName']
                ?.toString() ??
                "Customer";

        String customerPhone =
            data['customerPhone']
                ?.toString() ??
                "";

        String status =
            data['status']
                ?.toString() ??
                "Pending";

        double totalAmount =
        getDouble(
          data['totalAmount'],
        );

        return Card(
          margin: EdgeInsets.only(
            bottom: 12,
          ),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              15,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              15,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        orderNo,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                      EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration:
                      BoxDecoration(
                        color: Colors
                            .orange.shade50,
                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: Colors
                              .orange.shade800,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 15,
                ),

                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 20,
                      color:
                      Colors.grey.shade700,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        customerName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                if (customerPhone
                    .isNotEmpty) ...[
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 20,
                        color:
                        Colors.grey.shade700,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        customerPhone,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(
                  height: 8,
                ),

                Row(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 20,
                      color:
                      Colors.grey.shade700,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "${items.length} items",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 15,
                ),

                Divider(),

                SizedBox(
                  height: 5,
                ),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Text(
                      "Total Amount",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    Text(
                      "₹${totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Colors.green.shade700,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 15,
                ),

                SizedBox(
                  width: double.infinity,
                  child:
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (
                              context,
                              ) =>
                              Orderdetails(
                                orderId:
                                snap.id,
                              ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.visibility_outlined,
                    ),
                    label: Text(
                      "View Details",
                    ),
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.blue,
                      foregroundColor:
                      Colors.white,
                      padding:
                      EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
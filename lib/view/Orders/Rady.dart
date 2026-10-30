import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/orderdetail_viewmodel.dart';
class Orderready extends StatefulWidget {
  final String orderId;

  Orderready({
    super.key,
    required this.orderId,
  });

  @override
  State<Orderready> createState() =>
      _OrderreadyState();
}

class _OrderreadyState
    extends State<Orderready> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          OrderdetailViewmodel(
            orderId: widget.orderId,
          ),
      child: Consumer<
          OrderdetailViewmodel>(
        builder:
            (context, provider, child) {
          if (provider.loading) {
            return Scaffold(
              body: Center(
                child:
                CircularProgressIndicator(),
              ),
            );
          }

          var data =
              provider.orderData;

          var items =
              provider.items;

          return Scaffold(
            appBar: AppBar(
              backgroundColor:
              Colors.blue,
              title: Text(
                "View order Details",
              ),
            ),
            body: Padding(
              padding:
              EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child:
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    ListTile(
                      title: Text(
                        data['orderNo']
                            ?.toString() ??
                            "",
                        style:
                        TextStyle(
                          fontSize:
                          17,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                      subtitle: Text(
                        data['date'] !=
                            null
                            ? data['date']
                            .toDate()
                            .toString()
                            : "",
                      ),
                      trailing:
                      Card(
                        elevation: 5,
                        color: Colors
                            .indigoAccent
                            .shade100,
                        child: Text(
                          "   ${data['status']?.toString() ?? ""}   ",
                        ),
                      ),
                    ),

                    Card(
                      elevation: 5,
                      child: Container(
                        width:
                        double.infinity,
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius
                              .circular(
                            15,
                          ),
                        ),
                        child:
                        Column(
                          children: [
                            ListTile(
                              leading:
                              Icon(
                                Icons.person,
                              ),
                              title:
                              Text(
                                data['customerName']
                                    ?.toString() ??
                                    "Customer",
                              ),
                              subtitle:
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text(
                                    data['customerPhone']
                                        ?.toString() ??
                                        "",
                                  ),
                                  Text(
                                    data['address']
                                        ?.toString() ??
                                        "",
                                  ),
                                ],
                              ),
                              trailing:
                              Icon(
                                Icons.call,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Text(
                      "item(${items.length})",
                      style:
                      TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    Card(
                      elevation: 5,
                      child:
                      ListView.builder(
                        shrinkWrap:
                        true,
                        physics:
                        NeverScrollableScrollPhysics(),
                        itemCount:
                        items.length,
                        itemBuilder:
                            (context,
                            index) {
                          var item =
                          items[index];

                          double
                          itemTotal =
                          provider
                              .getItemTotal(
                            item,
                          );

                          return Column(
                            children: [
                              ListTile(
                                leading:
                                Icon(
                                  Icons
                                      .inventory_2,
                                ),
                                title:
                                Text(
                                  item['pname']
                                      ?.toString() ??
                                      "",
                                  style:
                                  TextStyle(
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                    fontSize:
                                    18,
                                  ),
                                ),
                                subtitle:
                                Text(
                                  "${item['qty']} × ₹${item['price']}",
                                  style:
                                  TextStyle(
                                    fontSize:
                                    15,
                                  ),
                                ),
                                trailing:
                                Text(
                                  "₹${itemTotal.toStringAsFixed(2)}",
                                  style:
                                  TextStyle(
                                    fontSize:
                                    20,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),

                    ListTile(
                      title: Text(
                        "Sub Total",
                        style:
                        TextStyle(
                          fontWeight:
                          FontWeight
                              .bold,
                          fontSize:
                          21,
                        ),
                      ),
                      trailing:
                      Text(
                        "₹${data['itemsTotal']?.toString() ?? '0'}",
                        style:
                        TextStyle(
                          fontSize:
                          21,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    ListTile(
                      title: Text(
                        "Delivery Charge",
                        style:
                        TextStyle(
                          fontWeight:
                          FontWeight
                              .bold,
                          fontSize:
                          21,
                        ),
                      ),
                      trailing:
                      Text(
                        "₹${data['deliveryCharge']?.toString() ?? '0'}",
                        style:
                        TextStyle(
                          fontSize:
                          21,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    Container(
                      width:
                      double.infinity,
                      color: Colors
                          .indigo
                          .shade100,
                      child: ListTile(
                        leading: Icon(
                          Icons.wallet,
                          color: Colors
                              .indigo,
                        ),
                        title: Text(
                          "Total Amount",
                          style:
                          TextStyle(
                            fontWeight:
                            FontWeight
                                .bold,
                            fontSize:
                            20,
                          ),
                        ),
                        trailing:
                        Text(
                          "₹${data['totalAmount']?.toString() ?? '0'}",
                          style:
                          TextStyle(
                            fontWeight:
                            FontWeight
                                .bold,
                            fontSize:
                            20,
                            color: Colors
                                .indigo,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Text(
                      "Update Order Status",
                      style:
                      TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 220,
                        child:
                        ElevatedButton(
                          onPressed:
                              () async {
                            await provider
                                .markCompleted(
                              context,
                            );
                          },
                          style:
                          ButtonStyle(
                            backgroundColor:
                            WidgetStatePropertyAll(
                              Colors.green,
                            ),
                            foregroundColor:
                            WidgetStatePropertyAll(
                              Colors.white,
                            ),
                          ),
                          child:
                          Text(
                            "Mark as Completed",
                            style:
                            TextStyle(
                              fontSize:
                              18,
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
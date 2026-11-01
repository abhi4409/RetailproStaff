import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retailprostaff/viewmodel/Detailbill_viewmodel.dart';

class Detailpbill extends StatefulWidget {
  final dynamic snap;

  Detailpbill({
    super.key,
    required this.snap,
  });

  @override
  State<Detailpbill> createState() =>
      _DetailpbillState();
}

class _DetailpbillState
    extends State<Detailpbill> {
  @override
  Widget build(
      BuildContext context,
      ) {
    return ChangeNotifierProvider(
      create: (context) =>
          DetailbillViewmodel(
            snap: widget.snap,
          ),
      child:
      Consumer<DetailbillViewmodel>(
        builder: (
            context,
            provider,
            child,
            ) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor:
              Colors.blue,
              foregroundColor:
              Colors.white,
              title: Text(
                "Bill Details",
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      elevation: 5,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            title: Text(
                              "Bill No: ${provider.billNo}",
                              style:
                              TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            leading:
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                              Colors
                                  .blue
                                  .shade100,
                              child: Icon(
                                Icons.receipt,
                                color:
                                Colors.blue,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .inventory_2,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${provider.items.length} items | ",
                                    ),
                                    Text(
                                      provider
                                          .paymentMethod,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .calendar_month,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Date: ${provider.billDate}",
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .access_time,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Time: ${provider.billTime}",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Card(
                              color: Colors
                                  .green
                                  .shade300,
                              child: Padding(
                                padding:
                                EdgeInsets
                                    .symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  "completed",
                                  style:
                                  TextStyle(
                                    color:
                                    Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      elevation: 5,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            title: Text(
                              "Customer Details",
                              style:
                              TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            leading:
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                              Colors
                                  .red
                                  .shade100,
                              child: Icon(
                                Icons.person,
                                color:
                                Colors.red,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "Name: ${provider.customerName}",
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Mob: ${provider.customerMobile}",
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.call,
                              color:
                              Colors.green,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      color:
                      Colors.blue.shade100,
                      elevation: 5,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),
                      ),
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Text(
                                "No",
                                style:
                                TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Product",
                                style:
                                TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Qty",
                                textAlign:
                                TextAlign
                                    .center,
                                style:
                                TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Rate",
                                textAlign:
                                TextAlign
                                    .center,
                                style:
                                TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Amount",
                                textAlign:
                                TextAlign.end,
                                style:
                                TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      color:
                      Colors.grey.shade100,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),
                      ),
                      child:
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                        NeverScrollableScrollPhysics(),
                        itemCount:
                        provider
                            .items
                            .length,
                        itemBuilder: (
                            context,
                            index,
                            ) {
                          final item =
                          provider
                              .items[index];

                          double amount =
                          provider
                              .getAmount(
                            item,
                          );

                          return Padding(
                            padding:
                            EdgeInsets
                                .symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      child: Text(
                                        "${index + 1}",
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        item['name']
                                            .toString(),
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                        style:
                                        TextStyle(
                                          fontWeight:
                                          FontWeight
                                              .w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        provider
                                            .formatQty(
                                          item,
                                        ),
                                        textAlign:
                                        TextAlign
                                            .center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "₹${item['price']}",
                                        textAlign:
                                        TextAlign
                                            .center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "₹${amount.toStringAsFixed(2)}",
                                        textAlign:
                                        TextAlign.end,
                                        style:
                                        TextStyle(
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (index !=
                                    provider
                                        .items
                                        .length -
                                        1)
                                  Divider(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      elevation: 5,
                      color:
                      Colors.blue.shade100,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "Subtotal",
                            ),
                            trailing: Text(
                              "₹${provider.totalAmount}",
                              style:
                              TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                          ),
                          ListTile(
                            title: Text(
                              "Discount",
                            ),
                            trailing: Text(
                              "₹0.00",
                              style:
                              TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                          ),
                          ListTile(
                            title: Text(
                              "Total Amount",
                              style:
                              TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            trailing: Text(
                              "₹${provider.totalAmount}",
                              style:
                              TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 20,
                                color: Colors
                                    .blue
                                    .shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width:
                      double.infinity,
                      height: 48,
                      child:
                      ElevatedButton.icon(
                        style: ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          Colors.blue,
                          foregroundColor:
                          Colors.white,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                          ),
                        ),
                        onPressed:
                            () async {
                          await provider
                              .printBill();
                        },
                        icon: Icon(
                          Icons.print,
                        ),
                        label: Text(
                          "Print Bill",
                          style:
                          TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight
                                .bold,
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
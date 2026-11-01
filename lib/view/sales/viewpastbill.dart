import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retailprostaff/viewmodel/viewbill_viewmodel.dart';
import 'Detailbill.dart';

class Viewpbills extends StatefulWidget {
  const Viewpbills({
    super.key,
  });

  @override
  State<Viewpbills> createState() => _ViewpbillsState();
}

class _ViewpbillsState extends State<Viewpbills> {
  @override
  Widget build(BuildContext context) {
    var provider =
    Provider.of<ViewbillViewmodel>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,

        title: Text(
          "view past bills",
        ),

        actions: [
          Icon(
            Icons.receipt,
          ),

          SizedBox(
            width: 5,
          ),
        ],
      ),

      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: provider.billStream,

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                "No bills found",
              ),
            );
          }

          var docs = snapshot.data!.docs;

          var filteredBills =
          provider.filterBills(
            docs,
          );

          return Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),

            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),

                  // SEARCH FIELD
                  TextField(
                    onChanged: (value) {
                      provider.searchBill(
                        value,
                      );
                    },

                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                      ),

                      hintText:
                      " Search bill no",

                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(
                          30,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // EMPTY SEARCH RESULT
                  if (filteredBills.isEmpty)
                    Padding(
                      padding:
                      EdgeInsets.all(
                        30,
                      ),

                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 60,
                            color: Colors.grey,
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Text(
                            "No bills found",
                          ),
                        ],
                      ),
                    ),

                  // BILL LIST
                  ListView.builder(
                    shrinkWrap: true,

                    physics:
                    NeverScrollableScrollPhysics(),

                    itemCount:
                    filteredBills.length,

                    itemBuilder:
                        (context, index) {
                      final snap =
                      filteredBills[index];

                      var data =
                      snap.data();

                      String billNo =
                          data['billno']
                              ?.toString() ??
                              "";

                      String paymentMethod =
                          data['paymentMethod']
                              ?.toString() ??
                              "";

                      List items =
                          data['items']
                          as List? ??
                              [];

                      return Padding(
                        padding:
                        EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),

                        child: Card(
                          elevation: 5,

                          color:
                          Colors.green.shade100,

                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),

                              ListTile(
                                title: Text(
                                  billNo,

                                  style:
                                  TextStyle(
                                    fontWeight:
                                    FontWeight.bold,

                                    fontSize:
                                    18,
                                  ),
                                ),

                                leading:
                                CircleAvatar(
                                  radius:
                                  20,

                                  backgroundColor:
                                  Colors.blue.shade100,

                                  child:
                                  Icon(
                                    Icons.receipt,

                                    color:
                                    Colors.blue,
                                  ),
                                ),

                                subtitle:
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                                  children: [
                                    SizedBox(
                                      height:
                                      10,
                                    ),

                                    Row(
                                      children: [
                                        Icon(
                                          Icons.inventory_2,
                                        ),

                                        SizedBox(
                                          width:
                                          5,
                                        ),

                                        Text(
                                          "${items.length} items | ",
                                        ),

                                        Expanded(
                                          child:
                                          Text(
                                            paymentMethod,

                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                trailing:
                                IconButton(
                                  onPressed:
                                      () {
                                    Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                            Detailpbill(
                                              snap:
                                              snap,
                                            ),
                                      ),
                                    );
                                  },

                                  icon:
                                  Icon(
                                    Icons.arrow_forward_ios,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
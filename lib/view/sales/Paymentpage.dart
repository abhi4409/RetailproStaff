import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retailprostaff/viewmodel/payment_viewmodel.dart';
import 'BillGenerate.dart';

class Payme extends StatefulWidget {
  final String billNo;
  final String customerName;
  final String customerMobile;
  final List<Map<String, dynamic>> cart;
  final double totalAmount;

  const Payme({
    super.key,
    required this.billNo,
    required this.customerName,
    required this.customerMobile,
    required this.cart,
    required this.totalAmount,
  });

  @override
  State<Payme> createState() => _PaymeState();
}

class _PaymeState extends State<Payme> {
  late PaymentViewmodel paymentViewmodel;

  @override
  void initState() {
    super.initState();

    paymentViewmodel = PaymentViewmodel(
      billNo: widget.billNo,
      customerName: widget.customerName,
      customerMobile: widget.customerMobile,
      cart: widget.cart,
      totalAmount: widget.totalAmount,

      onSuccess: () {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Payment completed successfully",
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Bill(
              billNo: widget.billNo,
              customerName: widget.customerName,
              customerMobile: widget.customerMobile,
              cart: widget.cart,
              totalAmount: widget.totalAmount,
              paymentMethod:
              paymentViewmodel.paymentMethod,
            ),
          ),
        );
      },

      onError: () {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Payment failed",
            ),
          ),
        );
      },

      onExternalWallet: () {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              "External wallet selected",
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    paymentViewmodel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: paymentViewmodel,

      child: Consumer<PaymentViewmodel>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Payment",
              ),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),

            body: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),

              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),

                      border: Border.all(
                        color: Colors.green,
                      ),
                    ),

                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),

                        Card(
                          elevation: 5,

                          color: Colors.blue.shade50,

                          child: Padding(
                            padding: EdgeInsets.all(
                              10,
                            ),

                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                  Colors.blue.shade100,

                                  radius: 30,

                                  child: Icon(
                                    Icons.shopping_cart,
                                    size: 25,
                                  ),
                                ),

                                SizedBox(
                                  width: 10,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                    children: [
                                      Text(
                                        "Bill number",

                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,

                                          fontSize: 15,
                                        ),
                                      ),

                                      Text(
                                        widget.billNo,

                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,

                                          fontSize: 20,
                                        ),
                                      ),

                                      SizedBox(
                                        height: 5,
                                      ),

                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 5,

                                        children: [
                                          Text(
                                            "Date: ${provider.now.day}/${provider.now.month}/${provider.now.year}",
                                          ),

                                          Text(
                                            "Time: ${provider.now.hour}:${provider.now.minute}",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "Total items",

                            style: TextStyle(
                              fontSize: 20,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          trailing: Text(
                            "${widget.cart.length}",

                            style: TextStyle(
                              fontSize: 15,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "Sub Total",
                          ),

                          trailing: Text(
                            "₹${widget.totalAmount.toStringAsFixed(2)}",

                            style: TextStyle(
                              fontSize: 15,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),

                        ListTile(
                          title: Text(
                            "Total discount",

                            style: TextStyle(
                              fontSize: 20,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          trailing: Text(
                            "₹ 0.00",

                            style: TextStyle(
                              fontSize: 15,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),

                        Divider(),

                        Card(
                          color: Colors.blue.shade50,

                          elevation: 5,

                          child: ListTile(
                            title: Text(
                              "Total amount",

                              style: TextStyle(
                                fontSize: 20,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            trailing: Text(
                              "₹${widget.totalAmount.toStringAsFixed(2)}",

                              style: TextStyle(
                                fontSize: 20,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    "Select the Payment method",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,

                      fontSize: 18,
                    ),
                  ),

                  Text(
                    "Choose how the customer is paying",

                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // CASH
                  Card(
                    elevation: 5,

                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 35,

                        backgroundColor:
                        Colors.green.shade100,

                        child: Icon(
                          Icons.money_sharp,

                          size: 30,

                          color: Colors.green,
                        ),
                      ),

                      title: Text(
                        "Cash",

                        style: TextStyle(
                          fontSize: 20,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        "Pay With Cash",
                      ),

                      trailing: Radio<String>(
                        value: "Cash",

                        groupValue:
                        provider.paymentMethod,

                        onChanged: (value) {
                          if (value != null) {
                            provider.changePayment(
                              value,
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // UPI
                  Card(
                    elevation: 5,

                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 35,

                        backgroundColor:
                        Colors.orange.shade100,

                        child: Icon(
                          Icons.paypal_sharp,

                          size: 30,

                          color: Colors.orange,
                        ),
                      ),

                      title: Text(
                        "UPI",

                        style: TextStyle(
                          fontSize: 20,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        "Pay with UPI (Google Pay, PhonePe etc)",
                      ),

                      trailing: Radio<String>(
                        value: "UPI",

                        groupValue:
                        provider.paymentMethod,

                        onChanged: (value) {
                          if (value != null) {
                            provider.changePayment(
                              value,
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // CARD
                  Card(
                    elevation: 5,

                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 35,

                        backgroundColor:
                        Colors.yellowAccent.shade100,

                        child: Icon(
                          Icons.payment,

                          size: 30,

                          color: Colors.indigo,
                        ),
                      ),

                      title: Text(
                        "Card",

                        style: TextStyle(
                          fontSize: 20,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        "Pay With debit/credit card",
                      ),

                      trailing: Radio<String>(
                        value: "Card",

                        groupValue:
                        provider.paymentMethod,

                        onChanged: (value) {
                          if (value != null) {
                            provider.changePayment(
                              value,
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    width: double.infinity,

                    height: 50,

                    child: ElevatedButton(
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.green,

                        foregroundColor:
                        Colors.white,
                      ),

                      onPressed:
                      provider.paymentMethod.isEmpty ||
                          provider.loading
                          ? null
                          : () async {
                        await provider
                            .confirmPayment();
                      },

                      child: provider.loading
                          ? SizedBox(
                        height: 25,
                        width: 25,

                        child:
                        CircularProgressIndicator(
                          color: Colors.white,

                          strokeWidth: 2,
                        ),
                      )
                          : Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 20,
                          ),

                          SizedBox(
                            width: 5,
                          ),

                          Text(
                            "Confirm Payment",

                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,

                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
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
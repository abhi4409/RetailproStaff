import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retailprostaff/viewmodel/Billinggenerate_viewmodel.dart';
import 'package:retailprostaff/viewmodel/addtobill_viewmodel.dart';
import 'Addtobill_view.dart';

class Bill extends StatefulWidget {
  final String customerName;
  final String billNo;
  final String customerMobile;
  final List<Map<String, dynamic>> cart;
  final double totalAmount;
  final String paymentMethod;

  Bill({
    super.key,
    required this.customerName,
    required this.billNo,
    required this.customerMobile,
    required this.cart,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  @override
  Widget build(
      BuildContext context,
      ) {
    return ChangeNotifierProvider(
      create: (
          context,
          ) => BillinggenerateViewmodel(
        customerName: widget.customerName,
        billNo: widget.billNo,
        customerMobile: widget.customerMobile,
        cart: widget.cart,
        totalAmount: widget.totalAmount,
        paymentMethod: widget.paymentMethod,
      ),
      child: Consumer<BillinggenerateViewmodel>(
        builder: (
            context,
            provider,
            child,
            ) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Bill Generated ",
              ),
              backgroundColor: Colors.green,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            25,
                          ),
                          color: Colors.green.shade100,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 80,
                            ),
                            Text(
                              "Payment Successful",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 15,
                              ),
                              child: Text(
                                "bill has been generated successfully",
                                style: TextStyle(
                                  fontSize: 19,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.store,
                                size: 80,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: 30,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Bill no",
                                ),
                                Text(
                                  provider.billNo,
                                ),
                                Text(
                                  "Date: ${provider.now.day}/${provider.now.month}/${provider.now.year}",
                                ),
                                Text(
                                  "Time: ${provider.now.hour}:${provider.now.minute}",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                        ),
                        title: Text(
                          provider.customerDisplayName,
                        ),
                        subtitle: Text(
                          provider.customerMobile,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Colors.blue.shade100,
                      elevation: 5,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  "NO",
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "product",
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "qty",
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "rate",
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "amount",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      elevation: 5,
                      color: Colors.grey.shade100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.cart.length,
                        itemBuilder: (
                            context,
                            index,
                            ) {
                          final item = provider.cart[index];
                          double price = provider.getPrice(
                            item,
                          );
                          String qty = provider.formatQty(
                            item,
                          );
                          double amount = provider.getAmount(
                            item,);

                          return Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${index + 1}",
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      item['name'],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "$qty",
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "₹$price",
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "₹${amount.toStringAsFixed(2)}",
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Card(
                      elevation: 5,
                      color: Colors.blue.shade100,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "subtotal",
                            ),
                            trailing: Text(
                              "₹${provider.totalAmount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              "discount",
                            ),
                            trailing: Text(
                              "₹0.00",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            trailing: Text(
                              "₹${provider.totalAmount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            title: Text(
                              "Total amount",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.grey.shade100,
                      child: Row(
                        children: [
                          Expanded(
                            child: Icon(
                              Icons.payment,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              provider.paymentMethod,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "₹${provider.totalAmount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: ()async {
                        await provider.printBill();
                        },
                                style: ButtonStyle(
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.blue,
                                  ),
                                ),
                                child: Text(
                                  "print",
                                ),
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  var billProvider =
                                  Provider.of<AddtobillViewmodel>(
                                    context,
                                    listen: false,
                                  );

                                  billProvider.newBill();

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Addpbill(),
                                    ),
                                  );
                                },

                                style: ButtonStyle(
                                  foregroundColor:
                                  WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  backgroundColor:
                                  WidgetStatePropertyAll(
                                    Colors.blue,
                                  ),
                                ),

                                child: Text(
                                  "New Bill",
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
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
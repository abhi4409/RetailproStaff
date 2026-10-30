import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/addtobill_viewmodel.dart';
import '../../viewmodel/billinggenerate_viewmodel.dart';
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BillinggenerateViewmodel(
        customerName: widget.customerName,
        billNo: widget.billNo,
        customerMobile: widget.customerMobile,
        cart: widget.cart,
        totalAmount: widget.totalAmount,
        paymentMethod: widget.paymentMethod,
      ),
      child: Consumer<BillinggenerateViewmodel>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Bill Generated"),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green.shade50,
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 70,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Payment Successful",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.green.shade900,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Bill has been generated successfully",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.store,
                            size: 50,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Retail Store",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Receipt / Tax Invoice",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Bill No: ${provider.billNo}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Date: ${provider.date}",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Time: ${provider.time}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(Icons.person, color: Colors.blue),
                      ),
                      title: Text(
                        provider.displayCustomerName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        provider.customerMobile.isEmpty
                            ? "No mobile number"
                            : provider.customerMobile,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Card(
                    color: Colors.blue.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Text(
                              "#",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Product",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Qty",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Rate",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Amount",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: provider.cart.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = provider.cart[index];
                        double price = provider.getPrice(item);
                        int qty = provider.getQty(item);
                        double amount = provider.getAmount(item);

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                                child: Text("${index + 1}"),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  item['name']?.toString() ?? "",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "$qty",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "₹${price.toStringAsFixed(2)}",
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "₹${amount.toStringAsFixed(2)}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Subtotal"),
                          trailing: Text(
                            "₹${provider.totalAmount.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Divider(height: 1),
                        ListTile(
                          title: Text("Discount"),
                          trailing: Text(
                            "₹0.00",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Divider(height: 1),
                        ListTile(
                          title: Text(
                            "Total Amount",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          trailing: Text(
                            "₹${provider.totalAmount.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.payment, color: Colors.blue),
                          SizedBox(width: 15),
                          Text(
                            "Payment Method:",
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(width: 8),
                          Text(
                            provider.paymentMethod.toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "₹${provider.totalAmount.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.print, color: Colors.blue),
                          label: Text(
                            "Print",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {

                            var billProvider =
                            Provider.of<AddtobillViewmodel>(
                              context,
                              listen: false,
                            );billProvider.newBill();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Addpbill(),
                              ),
                            );
                          },

                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),

                          label: Text(
                            "New Bill",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
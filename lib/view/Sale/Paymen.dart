import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/payment_viewmodel.dart';

class Payme extends StatefulWidget {
  final String billNo;
  final String customerName;
  final String customerMobile;
  final List<Map<String, dynamic>> cart;
  final double totalAmount;
  Payme({
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
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      paymentViewmodel.initializeRazorpay(context);
    });
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
              title: Text("Payment"),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                      "Bill No: ${provider.billNo}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Date: ${provider.now.day.toString().padLeft(2, '0')}/${provider.now.month.toString().padLeft(2, '0')}/${provider.now.year} • ${provider.now.hour.toString().padLeft(2, '0')}:${provider.now.minute.toString().padLeft(2, '0')}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Items",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                "${provider.cart.length}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                "₹${provider.totalAmount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Discount",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                "₹0.00",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Payable",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "₹${provider.totalAmount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Payment Method",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Select how the customer is paying",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildPaymentOption(
                    title: "Cash",
                    subtitle: "Pay directly with physical cash",
                    icon: Icons.payments_outlined,
                    iconColor: Colors.green,
                    iconBgColor: Colors.green.shade50,
                    value: "Cash",
                    groupValue: provider.paymentMethod,
                    onChanged: (val) {
                      if (val != null) provider.selectPaymentMethod(val);
                    },
                  ),
                  SizedBox(height: 10),
                  _buildPaymentOption(
                    title: "UPI",
                    subtitle: "Google Pay, PhonePe, Paytm, or UPI apps",
                    icon: Icons.qr_code_scanner,
                    iconColor: Colors.orange,
                    iconBgColor: Colors.orange.shade50,
                    value: "UPI",
                    groupValue: provider.paymentMethod,
                    onChanged: (val) {
                      if (val != null) provider.selectPaymentMethod(val);
                    },
                  ),
                  SizedBox(height: 10),
                  _buildPaymentOption(
                    title: "Card",
                    subtitle: "Credit or Debit Card swipe/tap",
                    icon: Icons.credit_card,
                    iconColor: Colors.indigo,
                    iconBgColor: Colors.indigo.shade50,
                    value: "Card",
                    groupValue: provider.paymentMethod,
                    onChanged: (val) {
                      if (val != null) provider.selectPaymentMethod(val);
                    },
                  ),
                  SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: provider.paymentMethod.isEmpty
                          ? null
                          : () async {
                        await provider.confirmPayment(context);
                      },
                      icon: Icon(Icons.check_circle_outline, size: 20),
                      label: Text(
                        "Confirm Payment",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
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

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final bool isSelected = value == groupValue;

    return Card(
      elevation: isSelected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: Colors.blue,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        secondary: CircleAvatar(
          radius: 20,
          backgroundColor: iconBgColor,
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
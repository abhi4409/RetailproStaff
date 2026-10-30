class PaymentModels {
  final String billNo;
  final String customerName;
  final String customerMobile;
  final List<Map<String, dynamic>> cart;
  final double totalAmount;

  String paymentMethod;
  DateTime now;

  PaymentModels({
    required this.billNo,
    required this.customerName,
    required this.customerMobile,
    required this.cart,
    required this.totalAmount,
    this.paymentMethod = "",
  }) : now = DateTime.now();
}
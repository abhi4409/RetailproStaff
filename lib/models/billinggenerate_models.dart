class BillinggenerateModels {
  String customerName;
  String billNo;
  String customerMobile;
  List<Map<String, dynamic>> cart;
  double totalAmount;
  String paymentMethod;
  DateTime now;

  BillinggenerateModels({
    required this.customerName,
    required this.billNo,
    required this.customerMobile,
    required this.cart,
    required this.totalAmount,
    required this.paymentMethod,
  }) : now = DateTime.now();
}
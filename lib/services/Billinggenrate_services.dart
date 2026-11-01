class BillinggenerateServices {
  String getCustomerDisplayName(String customerName) {
    return customerName.isEmpty ? "Walk in customer" : customerName;
  }

  double getPrice(Map<String, dynamic> item) {
    return double.tryParse(item['price'].toString()) ?? 0.0;
  }

  double getQty(Map<String, dynamic> item) {
    return double.tryParse(item['qty'].toString()) ?? 0.0;
  }

  double getAmount(Map<String, dynamic> item) {
    double price = double.tryParse(item['price'].toString()) ?? 0.0;
    double qty = double.tryParse(item['qty'].toString()) ?? 0.0;

    return price * qty;
  }
}
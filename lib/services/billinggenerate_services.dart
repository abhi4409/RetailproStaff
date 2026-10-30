class BillinggenerateServices {
  String displayCustomerName(String customerName) {
    if (customerName.trim().isEmpty) {
      return "Walk-in customer";
    }
    return customerName.trim();
  }
  String getDate(DateTime now) {
    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    return "$day/$month/${now.year}";
  }

  String getTime(DateTime now) {
    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  double getPrice(Map<String, dynamic> item) {
    return double.tryParse(item['price']?.toString() ?? '0') ?? 0.0;
  }

  int getQty(Map<String, dynamic> item) {
    return int.tryParse(item['qty']?.toString() ?? '0') ?? 0;
  }

  double getAmount(Map<String, dynamic> item) {
    return getPrice(item) * getQty(item);
  }
}
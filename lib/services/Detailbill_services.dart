import 'package:cloud_firestore/cloud_firestore.dart';

class DetailbillServices {
  List getItems(dynamic snap) => snap['items'] ?? [];

  String getBillNo(dynamic snap) => snap['billno']?.toString() ?? "";

  String getPaymentMethod(dynamic snap) =>
      snap['paymentMethod']?.toString() ?? "";

  String getCustomerName(dynamic snap) =>
      snap['customerName']?.toString() ?? "";

  String getCustomerMobile(dynamic snap) =>
      snap['customerMobile']?.toString() ?? "";

  String getTotalAmount(dynamic snap) =>
      snap['totalAmount']?.toString() ?? "0";

  double getPrice(dynamic item) {
    return double.tryParse(item['price'].toString()) ?? 0.0;
  }

  double getQty(dynamic item) {
    return double.tryParse(item['qty'].toString()) ?? 0.0;
  }

  double getAmount(dynamic item) {
    double price = double.tryParse(item['price'].toString()) ?? 0.0;
    double qty = double.tryParse(item['qty'].toString()) ?? 0.0;
    return price * qty;
  }

  String getBillDate(dynamic snap) {
    try {
      DateTime date = (snap['date'] as Timestamp).toDate();
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return "";
    }
  }

  String getBillTime(dynamic snap) {
    try {
      DateTime date = (snap['date'] as Timestamp).toDate();
      int hour = date.hour;
      String period = hour >= 12 ? "PM" : "AM";

      if (hour > 12) {
        hour -= 12;
      } else if (hour == 0) {
        hour = 12;
      }

      String minute = date.minute.toString().padLeft(2, '0');

      return "$hour:$minute $period";
    } catch (e) {
      return "";
    }
  }
}
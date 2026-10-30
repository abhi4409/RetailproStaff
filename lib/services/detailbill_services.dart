import 'package:cloud_firestore/cloud_firestore.dart';

class DetailbillServices {
  List<dynamic> getItems(dynamic snap) {
    return snap['items'] is List ? snap['items'] : [];
  }

  String getBillNo(dynamic snap) {
    return snap['billno']?.toString() ?? "";
  }

  String getPaymentMethod(dynamic snap) {
    return snap['paymentMethod']?.toString() ?? "";
  }

  String getCustomerName(dynamic snap) {
    return snap['customerName']?.toString() ?? "";
  }

  String getCustomerMobile(dynamic snap) {
    return snap['customerMobile']?.toString() ?? "";
  }

  String getTotalAmount(dynamic snap) {
    return snap['totalAmount']?.toString() ?? "0";
  }

  double getPrice(dynamic item) {
    return double.tryParse(item['price']?.toString() ?? '0') ?? 0.0;
  }

  int getQty(dynamic item) {
    return int.tryParse(item['qty']?.toString() ?? '0') ?? 0;
  }

  double getAmount(dynamic item) {
    return getPrice(item) * getQty(item);
  }

  String getBillDate(dynamic snap) {
    try {
      final rawDate = snap['date'];
      if (rawDate is! Timestamp) return "";

      DateTime date = rawDate.toDate();
      String day = date.day.toString().padLeft(2, '0');
      String month = date.month.toString().padLeft(2, '0');
      return "$day/$month/${date.year}";
    } catch (_) {
      return "";
    }
  }

  String getBillTime(dynamic snap) {
    try {
      final rawDate = snap['date'];
      if (rawDate is! Timestamp) return "";

      DateTime date = rawDate.toDate();
      int hour = date.hour;
      String period = hour >= 12 ? "PM" : "AM";

      if (hour > 12) {
        hour -= 12;
      } else if (hour == 0) {
        hour = 12;
      }

      String minute = date.minute.toString().padLeft(2, '0');
      return "$hour:$minute $period";
    } catch (_) {
      return "";
    }
  }
}
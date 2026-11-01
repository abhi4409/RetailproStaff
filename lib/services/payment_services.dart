import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentServices {
  final CollectionReference<Map<String, dynamic>> sales =
  FirebaseFirestore.instance.collection('sales');

  final CollectionReference<Map<String, dynamic>> products =
  FirebaseFirestore.instance.collection('productsdata');

  Future<void> addSale({
    required String billNo,
    required String customerName,
    required String customerMobile,
    required List<Map<String, dynamic>> cart,
    required double totalAmount,
    required String paymentMethod,
    required String paymentId,
  }) async {
    final data = {
      "customerName": customerName,
      "customerMobile": customerMobile,
      "items": cart,
      "totalAmount": totalAmount,
      "paymentMethod": paymentMethod,
      "paymentId": paymentId,
      "paymentStatus": "Paid",
      "date": FieldValue.serverTimestamp(),
      "billno": billNo,
    };

    await sales.add(data);
  }

  Future<void> updateStock(
      List<Map<String, dynamic>> cart,
      ) async {
    for (var item in cart) {
      String id = item['id']?.toString() ?? "";

      if (id.isEmpty) {
        continue;
      }

      var product = await products.doc(id).get();

      if (!product.exists) {
        continue;
      }

      var data = product.data();

      if (data == null) {
        continue;
      }

      double currentQty = double.tryParse(
        data['pquantity'].toString(),
      ) ?? 0;

      double soldQty = double.tryParse(
        item['qty'].toString(),
      ) ?? 0;

      double newQty = currentQty - soldQty;

      if (newQty < 0) {
        newQty = 0;
      }

      await products.doc(id).update({
        'pquantity': newQty.toString(),
      });
    }
  }
}
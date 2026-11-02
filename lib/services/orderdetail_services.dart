import 'package:cloud_firestore/cloud_firestore.dart';

class OrderdetailServices {
  final CollectionReference<Map<String, dynamic>> orders =
  FirebaseFirestore.instance.collection(
    'orders',
  );

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderDetails(
      String orderId,
      ) {
    return orders
        .doc(orderId)
        .snapshots();
  }

  Future<void> updateStatus(
      String orderId,
      String status,
      ) async {
    await orders
        .doc(orderId)
        .update({
      'status': status,
    });
  }
}
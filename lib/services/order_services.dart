import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices {
  final CollectionReference<Map<String, dynamic>> orders =
  FirebaseFirestore.instance.collection('orders');

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrders() {
    return orders.snapshots();
  }

  Future<void> updateStatus(
      String orderId,
      String status,
      ) async {
    await orders.doc(orderId).update({
      'status': status,
    });
  }
}
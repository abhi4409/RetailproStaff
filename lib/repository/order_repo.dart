import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/order_services.dart';

class OrderRepository {
  final OrderServices _services = OrderServices();

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrders() {
    return _services.getOrders();
  }

  Future<void> updateStatus(
      String orderId,
      String status,
      ) async {
    await _services.updateStatus(
      orderId,
      status,
    );
  }
}
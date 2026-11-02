import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/orderdetail_services.dart';

class OrderdetailRepository {
  final OrderdetailServices _services =
  OrderdetailServices();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderDetails(
      String orderId,
      ) {
    return _services.getOrderDetails(
      orderId,
    );
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

  Future<void> completeOrder(
      String orderId,
      ) async {
    await _services.completeOrder(
      orderId,
    );
  }
}
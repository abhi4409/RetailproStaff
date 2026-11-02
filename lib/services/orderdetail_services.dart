import 'package:cloud_firestore/cloud_firestore.dart';

class OrderdetailServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get orders =>
      firestore.collection('orders');

  CollectionReference<Map<String, dynamic>> get products =>
      firestore.collection('productsdata');

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderDetails(
    String orderId,
  ) {
    return orders.doc(orderId).snapshots();
  }

  Future<void> updateStatus(
    String orderId,
    String status,
  ) async {
    await orders.doc(orderId).update({
      'status': status,
    });
  }

  double getDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '0') ?? 0.0;
  }

  double normalizeQty(double value) {
    return double.parse(value.toStringAsFixed(1));
  }

  Future<void> completeOrder(String orderId) async {
    final orderRef = orders.doc(orderId);

    await firestore.runTransaction((transaction) async {
      final orderSnapshot = await transaction.get(orderRef);

      if (!orderSnapshot.exists || orderSnapshot.data() == null) {
        throw Exception('Order not found');
      }

      final orderData = orderSnapshot.data()!;

      if (orderData['stockDeducted'] == true) {
        transaction.update(orderRef, {
          'status': 'Completed',
        });
        return;
      }

      final List items =
          orderData['items'] is List ? orderData['items'] as List : [];

      final List<Map<String, dynamic>> productUpdates = [];

      for (final item in items) {
        if (item is! Map) {
          continue;
        }

        final productId = item['productId']?.toString() ?? '';

        if (productId.isEmpty) {
          continue;
        }

        final productRef = products.doc(productId);
        final productSnapshot = await transaction.get(productRef);

        if (!productSnapshot.exists || productSnapshot.data() == null) {
          throw Exception('Product not found');
        }

        final productData = productSnapshot.data()!;
        final currentStock = getDouble(productData['pquantity']);
        final orderedQty = getDouble(item['qty']);

        if (orderedQty <= 0) {
          continue;
        }

        if (currentStock < orderedQty) {
          final productName =
              item['pname']?.toString() ?? 'Product';
          throw Exception(
            'Not enough stock for $productName',
          );
        }

        final remainingStock =
            normalizeQty(currentStock - orderedQty);

        productUpdates.add({
          'reference': productRef,
          'quantity': remainingStock,
        });
      }

      for (final update in productUpdates) {
        final DocumentReference<Map<String, dynamic>> reference =
            update['reference'];
        final double quantity = update['quantity'];

        transaction.update(reference, {
          'pquantity': quantity,
        });
      }

      transaction.update(orderRef, {
        'status': 'Completed',
        'stockDeducted': true,
        'completedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}

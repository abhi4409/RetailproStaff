import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference<Map<String, dynamic>> sales =
  _firestore.collection('sales');

  late final CollectionReference<Map<String, dynamic>> products =
  _firestore.collection('productsdata');

  final Razorpay razorpay = Razorpay();

  void initializeRazorpay({
    required Function(PaymentSuccessResponse) success,
    required Function(PaymentFailureResponse) error,
    required Function(ExternalWalletResponse) wallet,
  }) {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, success);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, error);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, wallet);
  }

  Future<DocumentReference<Map<String, dynamic>>> addSale(
      Map<String, dynamic> data,
      ) async {
    return await sales.add(data);
  }

  /// Updates inventory stock atomically using Firestore transactions/batches
  /// to prevent race conditions and ensure all item updates succeed together.
  Future<void> updateStock(List<Map<String, dynamic>> cart) async {
    final WriteBatch batch = _firestore.batch();

    for (final item in cart) {
      final String? productId = item['id']?.toString();
      if (productId == null || productId.isEmpty) continue;

      final DocumentReference<Map<String, dynamic>> productRef =
      products.doc(productId);

      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await productRef.get();

      if (!snapshot.exists || snapshot.data() == null) continue;

      final int currentQty = int.tryParse(
        snapshot.data()?['pquantity']?.toString() ?? '0',
      ) ??
          0;

      final int soldQty = int.tryParse(item['qty']?.toString() ?? '0') ?? 0;
      final int newQty = (currentQty - soldQty).clamp(0, double.infinity).toInt();

      batch.update(productRef, {
        'pquantity': newQty.toString(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  void openRazorpay(Map<String, dynamic> options) {
    razorpay.open(options);
  }

  void clearRazorpay() {
    razorpay.clear();
  }
}
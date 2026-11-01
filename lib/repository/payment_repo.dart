import '../services/payment_services.dart';

class PaymentRepo {
  final PaymentServices service = PaymentServices();

  Future<void> addSale({
    required String billNo,
    required String customerName,
    required String customerMobile,
    required List<Map<String, dynamic>> cart,
    required double totalAmount,
    required String paymentMethod,
    required String paymentId,
  }) async {
    await service.addSale(
      billNo: billNo,
      customerName: customerName,
      customerMobile: customerMobile,
      cart: cart,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      paymentId: paymentId,
    );
  }

  Future<void> updateStock(
      List<Map<String, dynamic>> cart,
      ) async {
    await service.updateStock(
      cart,
    );
  }
}
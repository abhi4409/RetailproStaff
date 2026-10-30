import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../services/payment_services.dart';

class PaymentRepository {
  final PaymentServices _services =
  PaymentServices();

  void initializeRazorpay({
    required Function(PaymentSuccessResponse) success,
    required Function(PaymentFailureResponse) error,
    required Function(ExternalWalletResponse) wallet,
  }) {
    _services.initializeRazorpay(
      success: success,
      error: error,
      wallet: wallet,
    );
  }

  Future<void> addSale(
      Map<String, dynamic> data,
      ) async {
    await _services.addSale(
      data,
    );
  }

  Future<void> updateStock(
      List<Map<String, dynamic>> cart,
      ) async {
    await _services.updateStock(
      cart,
    );
  }

  void openRazorpay(
      Map<String, dynamic> options,
      ) {
    _services.openRazorpay(
      options,
    );
  }

  void clearRazorpay() {
    _services.clearRazorpay();
  }
}
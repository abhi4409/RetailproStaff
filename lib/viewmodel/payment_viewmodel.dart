import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/payment_models.dart';
import '../repository/payment_repo.dart';

class PaymentViewmodel extends ChangeNotifier {
  final PaymentRepo repo = PaymentRepo();

  final String billNo;
  final String customerName;
  final String customerMobile;
  final List<Map<String, dynamic>> cart;
  final double totalAmount;

  final VoidCallback onSuccess;
  final VoidCallback onError;
  final VoidCallback onExternalWallet;

  PaymentModels model = PaymentModels();

  late Razorpay razorpay;

  DateTime now = DateTime.now();

  PaymentViewmodel({
    required this.billNo,
    required this.customerName,
    required this.customerMobile,
    required this.cart,
    required this.totalAmount,
    required this.onSuccess,
    required this.onError,
    required this.onExternalWallet,
  }) {
    razorpay = Razorpay();
    razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      paymentSuccess,
    );

    razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      paymentError,
    );
    razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      externalWallet,
    );
  }
  String get paymentMethod {
    return model.paymentMethod;
  }
  bool get loading {
    return model.loading;
  }
  void changePayment(
      String value,
      ) {
    model.paymentMethod = value;
    notifyListeners();
  }
  void changeLoading(
      bool value,
      ) {
    model.loading = value;
    notifyListeners();
  }
  Future<void> addSale(
      String paymentId,
      ) async {
    await repo.addSale(
      billNo: billNo,
      customerName: customerName,
      customerMobile: customerMobile,
      cart: cart,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      paymentId: paymentId,
    );
  }
  Future<void> updateStock() async {
    await repo.updateStock(
      cart,
    );
  }
  void openRazorpay() {
    var options = {
      'key': 'rzp_test_To455asUanujcj',
      'amount': (totalAmount * 100).round(),
      'currency': 'INR',
      'name': 'Retail Pro',
      'description': 'Bill $billNo',
      'prefill': {
        'contact': customerMobile,
      },
    };
    try {
      razorpay.open(
        options,
      );
    } catch (e) {
      onError();
    }
  }
  Future<void> paymentSuccess(
      PaymentSuccessResponse response,
      ) async {
    try {
      changeLoading(
        true,
      );
      await addSale(
        response.paymentId ?? "",
      );

      await updateStock();

      onSuccess();
    } catch (e) {
      onError();
    } finally {
      changeLoading(
        false,
      );
    }
  }
  void paymentError(
      PaymentFailureResponse response,
      ) {
    onError();
  }
  void externalWallet(
      ExternalWalletResponse response,
      ) {
    onExternalWallet();
  }
  Future<void> cashPayment() async {
    try {
      changeLoading(
        true,
      );
      await addSale(
        "",
      );

      await updateStock();
      onSuccess();
    } catch (e) {
      onError();
    } finally {
      changeLoading(
        false,
      );
    }
  }
  Future<void> confirmPayment() async {
    if (paymentMethod.isEmpty) {
      return;
    }
    if (paymentMethod == "Cash") {
      await cashPayment();
    } else {
      openRazorpay();
    }
  }
  @override
  void dispose() {
    razorpay.clear();

    super.dispose();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/payment_models.dart';
import '../repository/payment_repo.dart';
import '../view/Sale/Genere.dart';

class PaymentViewmodel
    extends ChangeNotifier {
  late PaymentModels _model;

  final PaymentRepository _repository = PaymentRepository();

  PaymentViewmodel({
    required String billNo,
    required String customerName,
    required String customerMobile,
    required List<Map<String, dynamic>> cart,
    required double totalAmount,
  }) {
    _model =
        PaymentModels(
          billNo: billNo,
          customerName: customerName,
          customerMobile:
          customerMobile,
          cart: cart,
          totalAmount:
          totalAmount,
        );
  }

  String get billNo =>
      _model.billNo;

  String get customerName =>
      _model.customerName;

  String get customerMobile =>
      _model.customerMobile;

  List<Map<String, dynamic>>
  get cart =>
      _model.cart;

  double get totalAmount =>
      _model.totalAmount;

  String get paymentMethod =>
      _model.paymentMethod;

  DateTime get now =>
      _model.now;

  void initializeRazorpay(
      BuildContext context,
      ) {
    _repository.initializeRazorpay(
      success:
          (PaymentSuccessResponse response) {
        paymentSuccess(
          context,
          response,
        );
      },
      error:
          (PaymentFailureResponse response) {
        paymentError(
          context,
          response,
        );
      },
      wallet:
          (ExternalWalletResponse response) {
        externalWallet(
          context,
          response,
        );
      },
    );
  }

  void selectPaymentMethod(
      String value,
      ) {
    _model.paymentMethod =
        value;

    notifyListeners();
  }

  Future updateStock() async {
    await _repository.updateStock(
      _model.cart,
    );
  }

  Future addSale(
      String paymentId,
      ) async {
    final data = {
      "customerName":
      _model.customerName,
      "customerMobile":
      _model.customerMobile,
      "items":
      _model.cart,
      "totalAmount":
      _model.totalAmount,
      "paymentMethod":
      _model.paymentMethod,
      "paymentId":
      paymentId,
      "paymentStatus":
      "Paid",
      "date":
      FieldValue.serverTimestamp(),
      "billno":
      _model.billNo,
    };

    await _repository.addSale(
      data,
    );
  }

  void openRazorpay() {
    var options = {
      'key':
      'rzp_test_To455asUanujcj',
      'amount':
      (_model.totalAmount * 100)
          .round(),
      'currency':
      'INR',
      'name':
      'Retail Pro',
      'description':
      'Bill ${_model.billNo}',
      'prefill': {
        'contact':
        _model.customerMobile,
      },
    };

    try {
      _repository.openRazorpay(
        options,
      );
    } catch (e) {
      print(e);
    }
  }

  Future paymentSuccess(
      BuildContext context,
      PaymentSuccessResponse response,
      ) async {
    await addSale(
      response.paymentId ?? "",
    );

    await updateStock();

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        backgroundColor:
        Colors.green,
        content: Text(
          "Payment completed successfully",
        ),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Bill(
              billNo:
              _model.billNo,
              customerName:
              _model.customerName,
              customerMobile:
              _model.customerMobile,
              cart:
              _model.cart,
              totalAmount:
              _model.totalAmount,
              paymentMethod:
              _model.paymentMethod,
            ),
      ),
    );
  }

  void paymentError(
      BuildContext context,
      PaymentFailureResponse response,
      ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        backgroundColor:
        Colors.red,
        content: Text(
          "Payment failed",
        ),
      ),
    );
  }

  void externalWallet(
      BuildContext context,
      ExternalWalletResponse response,
      ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          "External wallet selected",
        ),
      ),
    );
  }

  Future confirmPayment(
      BuildContext context,
      ) async {
    if (_model.paymentMethod ==
        "Cash") {
      await addSale(
        "",
      );

      await updateStock();

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor:
          Colors.green,
          content: Text(
            "Payment completed successfully",
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Bill(
                billNo:
                _model.billNo,
                customerName:
                _model.customerName,
                customerMobile:
                _model.customerMobile,
                cart:
                _model.cart,
                totalAmount:
                _model.totalAmount,
                paymentMethod:
                _model.paymentMethod,
              ),
        ),
      );
    } else {
      openRazorpay();
    }
  }

  @override
  void dispose() {
    _repository.clearRazorpay();

    super.dispose();
  }
}
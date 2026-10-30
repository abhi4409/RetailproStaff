import 'package:flutter/material.dart';

import '../models/billinggenerate_models.dart';
import '../repository/billinggenerate_repo.dart';

class BillinggenerateViewmodel extends ChangeNotifier {
  final BillinggenerateRepository _repository =
  BillinggenerateRepository();

  late BillinggenerateModels _model;

  BillinggenerateViewmodel({
    required String customerName,
    required String billNo,
    required String customerMobile,
    required List<Map<String, dynamic>> cart,
    required double totalAmount,
    required String paymentMethod,
  }) {
    _model = BillinggenerateModels(
      customerName: customerName,
      billNo: billNo,
      customerMobile: customerMobile,
      cart: List<Map<String, dynamic>>.from(cart),
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
    );
  }

  String get customerName =>
      _model.customerName;

  String get billNo =>
      _model.billNo;

  String get customerMobile =>
      _model.customerMobile;

  List<Map<String, dynamic>> get cart =>
      _model.cart;

  double get totalAmount =>
      _model.totalAmount;

  String get paymentMethod =>
      _model.paymentMethod;

  String get displayCustomerName =>
      _repository.displayCustomerName(
        _model.customerName,
      );

  String get date =>
      _repository.getDate(
        _model.now,
      );

  String get time =>
      _repository.getTime(
        _model.now,
      );

  double getPrice(
      Map<String, dynamic> item,
      ) {
    return _repository.getPrice(
      item,
    );
  }

  int getQty(
      Map<String, dynamic> item,
      ) {
    return _repository.getQty(
      item,
    );
  }

  double getAmount(
      Map<String, dynamic> item,
      ) {
    return _repository.getAmount(
      item,
    );
  }
}
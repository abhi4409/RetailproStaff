import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/orderdetail_models.dart';
import '../repository/orderdetail_repo.dart';

class OrderdetailViewmodel extends ChangeNotifier {
  late OrderdetailModels _model;
  final OrderdetailRepository _repository = OrderdetailRepository();

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? orderSubscription;

  OrderdetailViewmodel({
    required String orderId,
  }) {
    _model = OrderdetailModels(
      orderId: orderId,
    );
    getOrderDetails();
  }

  String get orderId => _model.orderId;
  Map<String, dynamic> get orderData => _model.orderData;
  List<dynamic> get items => _model.items;
  bool get loading => _model.loading;

  void getOrderDetails() {
    orderSubscription = _repository
        .getOrderDetails(
      _model.orderId,
    )
        .listen(
          (snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          _model.orderData = snapshot.data()!;
          _model.items = _model.orderData['items'] is List
              ? _model.orderData['items']
              : [];
        }
        _model.loading = false;
        notifyListeners();
      },
    );
  }

  double getItemTotal(dynamic item) {
    double price = double.tryParse(item['price']?.toString() ?? '0') ?? 0.0;
    int qty = int.tryParse(item['qty']?.toString() ?? '0') ?? 0;
    return price * qty;
  }

  Future<void> acceptOrder(BuildContext context) async {
    await _repository.updateStatus(
      _model.orderId,
      'Accepted',
    );
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  Future<void> rejectOrder(BuildContext context) async {
    await _repository.updateStatus(
      _model.orderId,
      'Rejected',
    );
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  Future<void> makeReady(BuildContext context) async {
    await _repository.updateStatus(
      _model.orderId,
      'Ready',
    );
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  Future<void> markCompleted(BuildContext context) async {
    await _repository.updateStatus(
      _model.orderId,
      'Completed',
    );
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    orderSubscription?.cancel();
    super.dispose();
  }
}
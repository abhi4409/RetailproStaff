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

  double getDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '0') ?? 0.0;
  }

  bool isKgProduct(dynamic unit) {
    final value =
        unit?.toString().trim().toLowerCase() ?? '';

    return value == 'kg' ||
        value == 'kgs' ||
        value == 'kilogram' ||
        value == 'kilograms';
  }

  String displayQty(dynamic item) {
    final qty = getDouble(item['qty']);
    final unit = item['unit']?.toString() ?? '';

    String quantity;

    if (qty == qty.roundToDouble()) {
      quantity = qty.toInt().toString();
    } else {
      quantity = qty.toStringAsFixed(1);
    }

    if (isKgProduct(unit)) {
      return '$quantity KG';
    }

    if (unit.trim().isNotEmpty) {
      return '$quantity $unit';
    }

    return quantity;
  }

  double getItemTotal(dynamic item) {
    double price =
        getDouble(item['price']);
    double qty =
        getDouble(item['qty']);

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
    try {
      await _repository.completeOrder(
        _model.orderId,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Order completed successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    orderSubscription?.cancel();
    super.dispose();
  }
}

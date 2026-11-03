import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/orderdetail_models.dart';
import '../repository/orderdetail_repo.dart';

class OrderdetailViewmodel extends ChangeNotifier {
  late OrderdetailModels _model;
  final OrderdetailRepository _repository =
  OrderdetailRepository();

  StreamSubscription<
      DocumentSnapshot<Map<String, dynamic>>>? orderSubscription;

  OrderdetailViewmodel({
    required String orderId,
  }) {
    _model = OrderdetailModels(
      orderId: orderId,
    );

    getOrderDetails();
  }

  String get orderId =>
      _model.orderId;

  Map<String, dynamic> get orderData =>
      _model.orderData;

  List<dynamic> get items =>
      _model.items;

  bool get loading =>
      _model.loading;

  void getOrderDetails() {
    orderSubscription = _repository
        .getOrderDetails(
      _model.orderId,
    )
        .listen(
          (snapshot) {
        if (snapshot.exists &&
            snapshot.data() != null) {
          _model.orderData =
          snapshot.data()!;

          _model.items =
          _model.orderData['items'] is List
              ? _model.orderData['items']
              : [];
        }

        _model.loading = false;

        notifyListeners();
      },
    );
  }

  double getDouble(
      dynamic value,
      ) {
    if (value == null) {
      return 0.0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString().trim(),
    ) ??
        0.0;
  }

  double getItemPrice(
      dynamic item,
      ) {
    return getDouble(
      item['price'],
    );
  }

  double getItemQuantity(
      dynamic item,
      ) {
    return getDouble(
      item['qty'],
    );
  }

  double getItemTotal(
      dynamic item,
      ) {
    double price =
    getItemPrice(item);

    double qty =
    getItemQuantity(item);

    return price * qty;
  }

  String formatQuantity(
      dynamic value,
      ) {
    double qty =
    getDouble(value);

    if (qty ==
        qty.roundToDouble()) {
      return qty
          .toInt()
          .toString();
    }

    return qty
        .toStringAsFixed(2)
        .replaceAll(
      RegExp(r'0+$'),
      '',
    )
        .replaceAll(
      RegExp(r'\.$'),
      '',
    );
  }

  Future<void> acceptOrder(
      BuildContext context,
      ) async {
    await _repository.updateStatus(
      _model.orderId,
      'Accepted',
    );

    if (!context.mounted) {
      return;
    }

    Navigator.pop(context);
  }

  Future<void> rejectOrder(
      BuildContext context,
      ) async {
    await _repository.updateStatus(
      _model.orderId,
      'Rejected',
    );

    if (!context.mounted) {
      return;
    }

    Navigator.pop(context);
  }

  Future<void> makeReady(
      BuildContext context,
      ) async {
    await _repository.updateStatus(
      _model.orderId,
      'Ready',
    );

    if (!context.mounted) {
      return;
    }

    Navigator.pop(context);
  }

  Future<void> markCompleted(
      BuildContext context,
      ) async {
    await _repository.updateStatus(
      _model.orderId,
      'Completed',
    );

    if (!context.mounted) {
      return;
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    orderSubscription?.cancel();

    super.dispose();
  }
}
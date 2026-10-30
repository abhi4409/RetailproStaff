import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/sales_models.dart';
import '../repository/sales_repo.dart';


class SalesViewmodel extends ChangeNotifier {
  final SalesModels _model = SalesModels();
  final SalesRepository _repository = SalesRepository();

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? salesSubscription;

  SalesViewmodel() {
    getSales();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> get salesList =>
      _model.salesList;

  double get totalSales => _model.totalSales;
  double get cashSales => _model.cashSales;
  double get averageBill => _model.averageBill;
  bool get loading => _model.loading;

  void getSales() {
    salesSubscription = _repository.getSales().listen(
          (snapshot) {
        _model.salesList = snapshot.docs;
        calculateSales();
        _model.loading = false;
        notifyListeners();
      },
      onError: (error) {
        _model.loading = false;
        notifyListeners();
      },
    );
  }

  void calculateSales() {
    double runningTotal = 0.0;
    double runningCash = 0.0;

    for (var bill in _model.salesList) {
      final data = bill.data();

      final double amount = double.tryParse(
        data['totalAmount']?.toString() ?? '0',
      ) ??
          0.0;

      runningTotal += amount;

      final String paymentMethod =
          data['paymentMethod']?.toString().trim().toLowerCase() ?? '';

      if (paymentMethod == 'cash') {
        runningCash += amount;
      }
    }

    _model.totalSales = runningTotal;
    _model.cashSales = runningCash;
    _model.averageBill = _model.salesList.isNotEmpty
        ? runningTotal / _model.salesList.length
        : 0.0;
  }

  @override
  void dispose() {
    salesSubscription?.cancel();
    super.dispose();
  }
}
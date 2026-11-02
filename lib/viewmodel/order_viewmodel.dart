import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/order_models.dart';
import '../repository/order_repo.dart';

class OrderViewmodel extends ChangeNotifier {
  final OrderModels _model = OrderModels();
  final OrderRepository _repository = OrderRepository();

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? orderSubscription;

  OrderViewmodel() {
    getOrders();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> get allOrders =>
      _model.allOrders;

  bool get loading => _model.loading;

  void getOrders() {
    orderSubscription = _repository.getOrders().listen((snapshot) {
      _model.allOrders = snapshot.docs;
      _model.loading = false;
      notifyListeners();
    });
  }

  String getStatus(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return doc.data()['status']?.toString().trim().toLowerCase() ?? "";
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> get newOrders {
    return _model.allOrders.where((doc) {
      final status = getStatus(doc);
      return status == "pending" ||
          status == "order placed" ||
          status == "placed";
    }).toList();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> get acceptedOrders {
    return _model.allOrders.where((doc) {
      final status = getStatus(doc);
      return status == "accepted" || status == "accept";
    }).toList();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> get readyOrders {
    return _model.allOrders.where((doc) {
      final status = getStatus(doc);
      return status == "ready";
    }).toList();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> get completedOrders {
    return _model.allOrders.where((doc) {
      final status = getStatus(doc);
      return status == "completed";
    }).toList();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> get rejectedOrders {
    return _model.allOrders.where((doc) {
      final status = getStatus(doc);
      return status == "rejected";
    }).toList();
  }

  Future<void> updateStatus(
    String orderId,
    String status,
  ) async {
    await _repository.updateStatus(
      orderId,
      status,
    );
  }

  @override
  void dispose() {
    orderSubscription?.cancel();
    super.dispose();
  }
}

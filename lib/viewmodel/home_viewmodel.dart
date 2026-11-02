import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/home_models.dart';
import '../repository/home_repo.dart';

class HomeViewmodel extends ChangeNotifier {
  final HomeModels _model =
  HomeModels();

  final HomeRepository _repository =
  HomeRepository();

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  productSubscription;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  salesSubscription;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  orderSubscription;

  HomeViewmodel() {
    getProducts();
    getSales();
    getOrders();
  }

  int get productCount =>
      _model.productCount;

  int get lowStock =>
      _model.lowStock;

  int get billCount =>
      _model.billCount;

  double get todaySales =>
      _model.todaySales;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> get newOrders =>
      _model.newOrders;

  bool get productLoading =>
      _model.productLoading;

  bool get salesLoading =>
      _model.salesLoading;

  bool get orderLoading =>
      _model.orderLoading;

  bool get loading =>
      _model.productLoading ||
          _model.salesLoading;

  double getDouble(dynamic value) {
    return double.tryParse(
      value?.toString() ?? '0',
    ) ??
        0.0;
  }

  bool isNewOrder(
      Map<String, dynamic> data,
      ) {
    String status =
        data['status']
            ?.toString()
            .trim()
            .toLowerCase() ??
            '';

    return status == 'pending' ||
        status == 'order placed' ||
        status == 'placed';
  }

  void getProducts() {
    productSubscription =
        _repository
            .getProducts()
            .listen(
              (snapshot) {
            _model.productCount =
                snapshot.docs.length;

            _model.lowStock =
            0;

            for (var product
            in snapshot.docs) {
              var data =
              product.data();

              double quantity =
              getDouble(
                data['pquantity'],
              );

              double minStock =
              getDouble(
                data['pminstock'],
              );

              if (quantity <=
                  minStock) {
                _model.lowStock++;
              }
            }

            _model.productLoading =
            false;

            notifyListeners();
          },
        );
  }

  void getSales() {
    salesSubscription =
        _repository
            .getSales()
            .listen(
              (snapshot) {
            _model.billCount =
                snapshot.docs.length;

            _model.todaySales =
            0.0;

            DateTime now =
            DateTime.now();

            for (var sale
            in snapshot.docs) {
              var data =
              sale.data();

              double amount =
              getDouble(
                data['totalAmount'],
              );

              if (data['date']
              is Timestamp) {
                DateTime saleDate =
                (data['date']
                as Timestamp)
                    .toDate();

                if (saleDate.year ==
                    now.year &&
                    saleDate.month ==
                        now.month &&
                    saleDate.day ==
                        now.day) {
                  _model.todaySales +=
                      amount;
                }
              }
            }

            _model.salesLoading =
            false;

            notifyListeners();
          },
        );
  }

  void getOrders() {
    orderSubscription =
        _repository
            .getOrders()
            .listen(
              (snapshot) {
            _model.newOrders =
                snapshot.docs.where(
                      (doc) {
                    return isNewOrder(
                      doc.data(),
                    );
                  },
                ).toList();

            _model.orderLoading =
            false;

            notifyListeners();
          },
        );
  }

  @override
  void dispose() {
    productSubscription
        ?.cancel();

    salesSubscription
        ?.cancel();

    orderSubscription
        ?.cancel();

    super.dispose();
  }
}
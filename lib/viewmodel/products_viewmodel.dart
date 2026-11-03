import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/products_models.dart';
import '../repository/products_repo.dart';

class ProductsViewmodel extends ChangeNotifier {
  final ProductsModels _model =
  ProductsModels();

  final ProductsRepository _repository =
  ProductsRepository();

  StreamSubscription<
      QuerySnapshot<Map<String, dynamic>>>?
  productSubscription;

  ProductsViewmodel() {
    getProducts();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>>
  get productList =>
      _model.productList;

  List<QueryDocumentSnapshot<Map<String, dynamic>>>
  get filteredProducts =>
      _model.filteredProducts;

  String get searchText =>
      _model.searchText;

  bool get loading =>
      _model.loading;

  void getProducts() {
    productSubscription =
        _repository.getProducts().listen(
              (snapshot) {
            _model.productList =
                snapshot.docs;

            filterProducts();

            _model.loading =
            false;

            notifyListeners();
          },
          onError: (error) {
            print(
              "PRODUCT ERROR: $error",
            );

            _model.loading =
            false;

            notifyListeners();
          },
        );
  }

  void searchProduct(
      String value,
      ) {
    _model.searchText =
        value;

    filterProducts();

    notifyListeners();
  }

  void filterProducts() {
    _model.filteredProducts =
        _model.productList.where(
              (doc) {
            var data =
            doc.data();

            String productName =
                data['pname']
                    ?.toString()
                    .toLowerCase() ??
                    "";

            String barcode =
                data['pbarcode']
                    ?.toString()
                    .toLowerCase() ??
                    "";

            String search =
            _model.searchText
                .trim()
                .toLowerCase();

            return productName.contains(
              search,
            ) ||
                barcode.contains(
                  search,
                );
          },
        ).toList();
  }

  double getDouble(
      dynamic value,
      ) {
    return double.tryParse(
      value?.toString() ?? '0',
    ) ??
        0.0;
  }

  bool isOutOfStock(
      Map<String, dynamic> data,
      ) {
    double quantity =
    getDouble(
      data['pquantity'],
    );

    return quantity <= 0;
  }

  bool isLowStock(
      Map<String, dynamic> data,
      ) {
    double quantity =
    getDouble(
      data['pquantity'],
    );

    double minimumStock =
    getDouble(
      data['pminstock'],
    );

    return quantity > 0 &&
        quantity <= minimumStock;
  }

  bool isKgProduct(
      dynamic unit,
      ) {
    String value =
        unit
            ?.toString()
            .trim()
            .toLowerCase() ??
            "";

    return value == "kg" ||
        value == "kgs" ||
        value == "kilogram" ||
        value == "kilograms";
  }

  String displayQuantity(
      Map<String, dynamic> data,
      ) {
    double quantity =
    getDouble(
      data['pquantity'],
    );

    String unit =
        data['punits']
            ?.toString()
            .trim() ??
            "";

    String quantityText;

    if (quantity ==
        quantity.roundToDouble()) {
      quantityText =
          quantity
              .toInt()
              .toString();
    } else {
      quantityText =
          quantity
              .toStringAsFixed(1);
    }

    if (isKgProduct(unit)) {
      return "$quantityText KG";
    }

    if (unit.isNotEmpty) {
      return "$quantityText $unit";
    }

    return quantityText;
  }

  @override
  void dispose() {
    productSubscription
        ?.cancel();

    super.dispose();
  }
}
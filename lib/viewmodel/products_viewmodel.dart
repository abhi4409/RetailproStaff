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

            return productName.contains(
              _model.searchText
                  .toLowerCase(),
            );
          },
        ).toList();
  }

  @override
  void dispose() {
    productSubscription?.cancel();

    super.dispose();
  }
}
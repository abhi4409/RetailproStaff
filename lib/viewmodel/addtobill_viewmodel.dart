import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/addtobill_models.dart';
import '../repository/addtobill_repo.dart';

class AddtobillViewmodel extends ChangeNotifier {
  final AddtobillModels _addtobillModels = AddtobillModels();

  final AddtobillRepository _repository = AddtobillRepository();

  TextEditingController cusname = TextEditingController();

  TextEditingController cusnum = TextEditingController();

  StreamSubscription? productSubscription;

  AddtobillViewmodel() {
    getProducts();
  }

  String get selectedcustomer => _addtobillModels.selectedcustomer;

  String get searchText => _addtobillModels.searchText;

  List<Map<String, dynamic>> get cart => _addtobillModels.cart;

  List<QueryDocumentSnapshot> get productDocs => _addtobillModels.productDocs;

  bool get loading => _addtobillModels.loading;

  void getProducts() {
    productSubscription = _repository.getProducts().listen(
          (snapshot) {
        _addtobillModels.productDocs = snapshot.docs;

        _addtobillModels.loading = false;

        notifyListeners();
      },
    );
  }

  List<QueryDocumentSnapshot> get filteredProducts =>
      _addtobillModels.productDocs.where(
            (doc) {
          var data = doc.data() as Map<String, dynamic>;

          String productName =
              data['pname']?.toString().toLowerCase() ?? "";

          return productName.contains(
            _addtobillModels.searchText.toLowerCase(),
          );
        },
      ).toList();

  void searchProduct(
      String value,
      ) {
    _addtobillModels.searchText = value;

    notifyListeners();
  }

  void changeCustomer(
      String value,
      ) {
    _addtobillModels.selectedcustomer = value;

    notifyListeners();
  }

  Future<String> getBillNumber() async {
    return await _repository.getBillNumber();
  }

  Future addSale() async {
    final data = {
      "customerName": cusname.text,
      "customerMobile": cusnum.text,
      "items": _addtobillModels.cart,
      "date": FieldValue.serverTimestamp(),
    };

    await _repository.addSale(
      data,
    );
  }

  void addtocart(
      String id,
      String name,
      String price,
      String unit,
      String mrp,
      ) {
    _addtobillModels.cart.add(
      {
        'id': id,
        'name': name,
        'price': price,
        'unit': unit,
        'qty': 1,
        'mrp': mrp,
      },
    );

    notifyListeners();
  }

  void increseqty(
      int index,
      ) {
    _addtobillModels.cart[index]['qty']++;

    notifyListeners();
  }

  void decreseqty(
      int index,
      ) {
    if (_addtobillModels.cart[index]['qty'] > 1) {
      _addtobillModels.cart[index]['qty']--;

      notifyListeners();
    }
  }

  void clearcart() {
    _addtobillModels.cart.clear();

    notifyListeners();
  }

  void itemdelete(
      int index,
      ) {
    _addtobillModels.cart.removeAt(
      index,
    );

    notifyListeners();
  }

  double get totalAmount {
    double total = 0;

    for (var item in _addtobillModels.cart) {
      double price = double.tryParse(
        item['price'].toString(),
      ) ??
          0;

      int qty = int.tryParse(
        item['qty'].toString(),
      ) ??
          0;

      total += price * qty;
    }

    return total;
  }

  void newBill() {
    _addtobillModels.cart.clear();

    cusname.clear();

    cusnum.clear();

    _addtobillModels.searchText = "";

    _addtobillModels.selectedcustomer = "walk in customer";

    notifyListeners();
  }

  @override
  void dispose() {
    productSubscription?.cancel();

    cusname.dispose();

    cusnum.dispose();

    super.dispose();
  }
}
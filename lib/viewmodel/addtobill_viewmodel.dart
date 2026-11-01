import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddtobillViewmodel extends ChangeNotifier {
  final CollectionReference products =
  FirebaseFirestore.instance.collection('productsdata');

  final CollectionReference billCounter =
  FirebaseFirestore.instance.collection('counters');

  TextEditingController cusname = TextEditingController();
  TextEditingController cusnum = TextEditingController();

  String selectedcustomer = "walk in customer";
  String searchText = "";

  bool loading = false;
  bool generatingBill = false;

  List<QueryDocumentSnapshot> allProducts = [];
  List<QueryDocumentSnapshot> filteredProducts = [];
  List<Map<String, dynamic>> cart = [];

  StreamSubscription? productSubscription;

  AddtobillViewmodel() {
    getProducts();
  }

  void getProducts() {
    loading = true;
    notifyListeners();

    productSubscription = products.snapshots().listen(
          (snapshot) {
        allProducts = snapshot.docs;

        filterProducts();

        loading = false;

        notifyListeners();
      },
      onError: (error) {
        loading = false;
        notifyListeners();
      },
    );
  }

  void searchProduct(String value) {
    searchText = value;
    filterProducts();
    notifyListeners();
  }

  void filterProducts() {
    filteredProducts = allProducts.where(
          (doc) {
        String productName =
        doc['pname'].toString().toLowerCase();

        return productName.contains(
          searchText.toLowerCase(),
        );
      },
    ).toList();
  }

  void changeCustomer(String value) {
    selectedcustomer = value;
    notifyListeners();
  }

  bool isKg(String unit) {
    return unit.toLowerCase().trim() == "kg";
  }

  void addtocart(
      String id,
      String name,
      String price,
      String unit,
      String mrp,
      ) {
    int index = cart.indexWhere(
          (item) => item['id'] == id,
    );

    if (index != -1) {
      double qty =
          double.tryParse(
            cart[index]['qty'].toString(),
          ) ??
              0.0;

      if (isKg(unit)) {
        qty = qty + 0.1;
      } else {
        qty = qty + 1;
      }

      cart[index]['qty'] =
          double.parse(
            qty.toStringAsFixed(2),
          );
    } else {
      cart.add({
        'id': id,
        'name': name,
        'price': price,
        'unit': unit,
        'qty': isKg(unit) ? 0.1 : 1,
        'mrp': mrp,
      });
    }

    notifyListeners();
  }

  void increseqty(int index) {
    double qty =
        double.tryParse(
          cart[index]['qty'].toString(),
        ) ??
            0.0;

    String unit =
    cart[index]['unit'].toString();

    if (isKg(unit)) {
      qty = qty + 0.1;
    } else {
      qty = qty + 1;
    }

    cart[index]['qty'] =
        double.parse(
          qty.toStringAsFixed(2),
        );

    notifyListeners();
  }

  void decreseqty(int index) {
    double qty =
        double.tryParse(
          cart[index]['qty'].toString(),
        ) ??
            0.0;

    String unit =
    cart[index]['unit'].toString();

    if (isKg(unit)) {
      if (qty > 0.1) {
        qty = qty - 0.1;
      }
    } else {
      if (qty > 1) {
        qty = qty - 1;
      }
    }

    cart[index]['qty'] =
        double.parse(
          qty.toStringAsFixed(2),
        );

    notifyListeners();
  }

  void changeKgQty(
      int index,
      double qty,
      ) {
    String unit =
    cart[index]['unit'].toString();

    if (!isKg(unit)) {
      return;
    }

    if (qty <= 0) {
      return;
    }

    cart[index]['qty'] =
        double.parse(
          qty.toStringAsFixed(2),
        );

    notifyListeners();
  }

  void itemdelete(int index) {
    cart.removeAt(index);
    notifyListeners();
  }

  void clearcart() {
    cart.clear();
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;

    for (var item in cart) {
      double price =
          double.tryParse(
            item['price'].toString(),
          ) ??
              0.0;

      double qty =
          double.tryParse(
            item['qty'].toString(),
          ) ??
              0.0;

      total = total + (price * qty);
    }

    return total;
  }

  Future<String> getBillNumber() async {
    var reference =
    billCounter.doc('bill');

    var doc =
    await reference.get();

    int number = 1;

    if (doc.exists) {
      var data =
      doc.data() as Map<String, dynamic>?;

      int lastNumber =
          int.tryParse(
            data?['lastNumber']
                ?.toString() ??
                "0",
          ) ??
              0;

      number = lastNumber + 1;

      await reference.update({
        'lastNumber': number,
      });
    } else {
      await reference.set({
        'lastNumber': number,
      });
    }

    return "RP-$number";
  }

  Future<String?> generateBill() async {
    if (cart.isEmpty) {
      return null;
    }

    try {
      generatingBill = true;
      notifyListeners();

      String billNo =
      await getBillNumber();

      return billNo;
    } catch (e) {
      print(
        "Generate bill error: $e",
      );

      return null;
    } finally {
      generatingBill = false;
      notifyListeners();
    }
  }

  void newBill() {
    cart.clear();
    cusname.clear();
    cusnum.clear();

    searchText = "";

    selectedcustomer =
    "walk in customer";

    filterProducts();

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
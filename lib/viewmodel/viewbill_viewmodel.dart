import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/viewbill_models.dart';
import '../repository/viewbill_repo.dart';
class ViewbillViewmodel extends ChangeNotifier {
  final ViewbillRepo repo = ViewbillRepo();

  ViewbillModels model = ViewbillModels();

  String get searchText => model.searchText;

  Stream<QuerySnapshot<Map<String, dynamic>>> get billStream {
    return repo.getBills();
  }

  void searchBill(String value) {
    model.searchText = value;
    notifyListeners();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> filterBills(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      ) {
    return docs.where((doc) {
      var data = doc.data();

      String billNo =
          data['billno']?.toString().toLowerCase() ?? "";

      return billNo.contains(
        searchText.toLowerCase(),
      );
    }).toList();
  }
}
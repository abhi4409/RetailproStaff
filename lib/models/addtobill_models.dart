import 'package:cloud_firestore/cloud_firestore.dart';

class AddtobillModels {
  String selectedcustomer;
  String searchText;
  List<Map<String, dynamic>> cart;
  List<QueryDocumentSnapshot> productDocs;
  bool loading;

  AddtobillModels({
    this.selectedcustomer = "walk in customer",
    this.searchText = "",
    List<Map<String, dynamic>>? cart,
    List<QueryDocumentSnapshot>? productDocs,
    this.loading = true,
  })  : cart = cart ?? [],
        productDocs = productDocs ?? [];
}
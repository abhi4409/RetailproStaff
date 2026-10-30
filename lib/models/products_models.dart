import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModels {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> productList;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredProducts;
  String searchText;
  bool loading;

  ProductsModels({
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? productList,
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? filteredProducts,
    this.searchText = "",
    this.loading = true,
  })  : productList = productList ?? [],
        filteredProducts = filteredProducts ?? [];
}
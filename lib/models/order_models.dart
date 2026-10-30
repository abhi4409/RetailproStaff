import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModels {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allOrders;
  bool loading;

  OrderModels({
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? allOrders,
    this.loading = true,
  }) : allOrders = allOrders ?? [];
}
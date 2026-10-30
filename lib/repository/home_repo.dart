import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/home_services.dart';

class HomeRepository {
  final HomeServices _services =
  HomeServices();

  Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return _services.getProducts();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getSales() {
    return _services.getSales();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getOrders() {
    return _services.getOrders();
  }
}
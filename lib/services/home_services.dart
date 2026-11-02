import 'package:cloud_firestore/cloud_firestore.dart';

class HomeServices {
  final CollectionReference<Map<String, dynamic>> products =
  FirebaseFirestore.instance.collection(
    'productsdata',
  );

  final CollectionReference<Map<String, dynamic>> sales =
  FirebaseFirestore.instance.collection(
    'sales',
  );

  final CollectionReference<Map<String, dynamic>> orders =
  FirebaseFirestore.instance.collection(
    'orders',
  );

  Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return products.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSales() {
    return sales.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrders() {
    return orders.snapshots();
  }
}
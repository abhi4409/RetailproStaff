import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsServices {
  final CollectionReference<Map<String, dynamic>> products =
  FirebaseFirestore.instance.collection(
    'productsdata',
  );

  Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return products.snapshots();
  }
}
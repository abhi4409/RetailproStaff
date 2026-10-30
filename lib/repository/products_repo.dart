import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/products_services.dart';

class ProductsRepository {
  final ProductsServices _services =
  ProductsServices();

  Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return _services.getProducts();
  }
}
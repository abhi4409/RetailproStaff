import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/sales_services.dart';

class SalesRepository {
  final SalesServices _services =
  SalesServices();

  Stream<QuerySnapshot<Map<String, dynamic>>> getSales() {
    return _services.getSales();
  }
}
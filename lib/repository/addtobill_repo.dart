import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/addtobill_services.dart';

class AddtobillRepository {
  final AddtobillServices _services =
  AddtobillServices();

  Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return _services.getProducts();
  }

  Future<String> getBillNumber() async {
    return await _services.getBillNumber();
  }

  Future<void> addSale(
      Map<String, dynamic> data,
      ) async {
    await _services.addSale(data);
  }
}
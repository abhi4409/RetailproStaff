import 'package:cloud_firestore/cloud_firestore.dart';

class ViewbillServices {
  final CollectionReference<Map<String, dynamic>> sales =
  FirebaseFirestore.instance.collection('sales');

  Stream<QuerySnapshot<Map<String, dynamic>>> getBills() {
    return sales.snapshots();
  }
}
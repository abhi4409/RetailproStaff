import 'package:cloud_firestore/cloud_firestore.dart';

class SalesServices {
  final CollectionReference<Map<String, dynamic>> sales =
  FirebaseFirestore.instance.collection(
    'sales',
  );

  Stream<QuerySnapshot<Map<String, dynamic>>> getSales() {
    return sales
        .orderBy(
      'date',
      descending: true,
    )
        .snapshots();
  }
}
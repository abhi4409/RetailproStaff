import 'package:cloud_firestore/cloud_firestore.dart';

class AddtobillServices {
  final CollectionReference<Map<String, dynamic>> products =
  FirebaseFirestore.instance.collection('productsdata');

  final CollectionReference<Map<String, dynamic>> billCounter =
  FirebaseFirestore.instance.collection('counters');

  final CollectionReference<Map<String, dynamic>> sales =
  FirebaseFirestore.instance.collection('sales');

  Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return products.snapshots();
  }

  Future<String> getBillNumber() async {
    var doc =
    await billCounter.doc('bill').get();

    int number =
        int.tryParse(
          doc.data()?['lastNumber']?.toString() ?? '0',
        ) ??
            0;

    number++;

    if (doc.exists) {
      await billCounter.doc('bill').update({
        'lastNumber': number,
      });
    } else {
      await billCounter.doc('bill').set({
        'lastNumber': number,
      });
    }

    return "RP-$number";
  }

  Future<void> addSale(
      Map<String, dynamic> data,
      ) async {
    await sales.add(data);
  }
}
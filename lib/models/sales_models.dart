import 'package:cloud_firestore/cloud_firestore.dart';

class SalesModels {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> salesList;

  double totalSales;
  double cashSales;
  double averageBill;

  bool loading;

  SalesModels({
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? salesList,
    this.totalSales = 0,
    this.cashSales = 0,
    this.averageBill = 0,
    this.loading = true,
  }) : salesList = salesList ?? [];
}
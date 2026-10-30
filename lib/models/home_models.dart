import 'package:cloud_firestore/cloud_firestore.dart';

class HomeModels {
  int productCount;
  int lowStock;
  int billCount;
  double todaySales;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> newOrders;
  bool productLoading;
  bool salesLoading;
  bool orderLoading;
  HomeModels({
    this.productCount = 0,
    this.lowStock = 0,
    this.billCount = 0,
    this.todaySales = 0,
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? newOrders,
    this.productLoading = true,
    this.salesLoading = true,
    this.orderLoading = true,
  }) : newOrders = newOrders ?? [];
}
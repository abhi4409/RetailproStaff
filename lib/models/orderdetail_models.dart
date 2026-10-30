class OrderdetailModels {
  final String orderId;
  Map<String, dynamic> orderData;
  List items;
  bool loading;
  OrderdetailModels({
    required this.orderId,
    Map<String, dynamic>? orderData,
    List? items,
    this.loading = true,
  })  : orderData = orderData ?? {},
        items = items ?? [];
}
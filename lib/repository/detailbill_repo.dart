import '../services/detailbill_services.dart';

class DetailbillRepository {
  final DetailbillServices _services = DetailbillServices();

  List<dynamic> getItems(dynamic snap) => _services.getItems(snap);

  String getBillNo(dynamic snap) => _services.getBillNo(snap);

  String getPaymentMethod(dynamic snap) => _services.getPaymentMethod(snap);

  String getCustomerName(dynamic snap) => _services.getCustomerName(snap);

  String getCustomerMobile(dynamic snap) => _services.getCustomerMobile(snap);

  String getTotalAmount(dynamic snap) => _services.getTotalAmount(snap);

  double getPrice(dynamic item) => _services.getPrice(item);

  int getQty(dynamic item) => _services.getQty(item);

  double getAmount(dynamic item) => _services.getAmount(item);

  String getBillDate(dynamic snap) => _services.getBillDate(snap);

  String getBillTime(dynamic snap) => _services.getBillTime(snap);
}
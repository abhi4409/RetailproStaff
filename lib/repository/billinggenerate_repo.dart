import '../services/billinggenerate_services.dart';

class BillinggenerateRepository {
  final BillinggenerateServices _services = BillinggenerateServices();

  String displayCustomerName(String customerName) =>
      _services.displayCustomerName(customerName);

  String getDate(DateTime now) => _services.getDate(now);

  String getTime(DateTime now) => _services.getTime(now);

  double getPrice(Map<String, dynamic> item) => _services.getPrice(item);

  int getQty(Map<String, dynamic> item) => _services.getQty(item);

  double getAmount(Map<String, dynamic> item) => _services.getAmount(item);
}
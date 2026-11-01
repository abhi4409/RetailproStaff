import 'package:retailprostaff/services/Billinggenrate_services.dart';

class BillinggenerateRepository {
  final BillinggenerateServices _services = BillinggenerateServices();

  String getCustomerDisplayName(String customerName) =>
      _services.getCustomerDisplayName(customerName);

  double getPrice(Map<String, dynamic> item) =>
      _services.getPrice(item);

  double getQty(Map<String, dynamic> item) =>
      _services.getQty(item);

  double getAmount(Map<String, dynamic> item) =>
      _services.getAmount(item);
}
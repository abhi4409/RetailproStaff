import 'package:flutter/material.dart';

import '../models/detailbill_models.dart';
import '../repository/detailbill_repo.dart';

class DetailbillViewmodel extends ChangeNotifier {
  late DetailbillModels _model;
  final DetailbillRepository _repository = DetailbillRepository();

  DetailbillViewmodel({
    required dynamic snap,
  }) {
    _model = DetailbillModels(
      snap: snap,
    );
  }

  List<dynamic> get items => _repository.getItems(_model.snap);
  String get billNo => _repository.getBillNo(_model.snap);
  String get paymentMethod => _repository.getPaymentMethod(_model.snap);
  String get customerName => _repository.getCustomerName(_model.snap);
  String get customerMobile => _repository.getCustomerMobile(_model.snap);
  String get totalAmount => _repository.getTotalAmount(_model.snap);
  double getPrice(dynamic item) => _repository.getPrice(item);
  int getQty(dynamic item) => _repository.getQty(item);
  double getAmount(dynamic item) => _repository.getAmount(item);
  String get billDate => _repository.getBillDate(_model.snap);
  String get billTime => _repository.getBillTime(_model.snap);
}
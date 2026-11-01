import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retailprostaff/services/viewbill_services.dart';

class ViewbillRepo {
  final ViewbillServices service = ViewbillServices();

  Stream<QuerySnapshot<Map<String, dynamic>>> getBills() {
    return service.getBills();
  }
}
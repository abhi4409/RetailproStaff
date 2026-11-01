import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/Detailbill_model.dart';
import '../repository/Detailbill_repository.dart';

class DetailbillViewmodel extends ChangeNotifier {
  late DetailbillModels _detailbillModels;
  final DetailbillRepository _repository = DetailbillRepository();

  DetailbillViewmodel({
    required dynamic snap,
  }) {
    _detailbillModels = DetailbillModels(
      snap: snap,
    );
  }

  dynamic get snap => _detailbillModels.snap;

  List get items =>
      _repository.getItems(_detailbillModels.snap);

  String get billNo =>
      _repository.getBillNo(_detailbillModels.snap);

  String get paymentMethod =>
      _repository.getPaymentMethod(_detailbillModels.snap);

  String get customerName =>
      _repository.getCustomerName(_detailbillModels.snap);

  String get customerMobile =>
      _repository.getCustomerMobile(_detailbillModels.snap);

  String get totalAmount =>
      _repository.getTotalAmount(_detailbillModels.snap);

  String get billDate =>
      _repository.getBillDate(_detailbillModels.snap);

  String get billTime =>
      _repository.getBillTime(_detailbillModels.snap);

  double getPrice(dynamic item) {
    return _repository.getPrice(item);
  }

  double getQty(dynamic item) {
    return _repository.getQty(item);
  }

  double getAmount(dynamic item) {
    return _repository.getAmount(item);
  }

  String formatQty(dynamic item) {
    double qty = double.tryParse(
      item['qty'].toString(),
    ) ?? 0.0;

    String unit =
        item['unit']?.toString() ?? "";

    if (unit.toLowerCase().trim() == "kg") {
      String quantity = qty
          .toStringAsFixed(2)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');

      return "$quantity kg";
    }

    return qty.toInt().toString();
  }

  Future<void> printBill() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(30),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                "RETAIL PRO",
                style: pw.TextStyle(
                  fontSize: 26,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Center(
              child: pw.Text(
                "Receipt / Tax Invoice",
                style: pw.TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment:
              pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Bill No: $billNo",
                ),
                pw.Text(
                  "Date: $billDate",
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment:
              pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Payment: $paymentMethod",
                ),
                pw.Text(
                  "Time: $billTime",
                ),
              ],
            ),
            pw.SizedBox(height: 15),
            pw.Text(
              "Customer Details",
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              customerName.isEmpty
                  ? "Customer: Walk in customer"
                  : "Customer: $customerName",
            ),
            pw.Text(
              customerMobile.isEmpty
                  ? "Mobile: -"
                  : "Mobile: $customerMobile",
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Row(
              children: [
                pw.SizedBox(
                  width: 30,
                  child: pw.Text(
                    "No",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    "Product",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    "Qty",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    "Rate",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    "Amount",
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            pw.Divider(),
            ...List.generate(
              items.length,
                  (index) {
                final item = items[index];

                double price = getPrice(
                  item,
                );

                double amount = getAmount(
                  item,
                );

                String qty = formatQty(
                  item,
                );

                return pw.Column(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                        vertical: 7,
                      ),
                      child: pw.Row(
                        children: [
                          pw.SizedBox(
                            width: 30,
                            child: pw.Text(
                              "${index + 1}",
                            ),
                          ),
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              item['name']?.toString() ?? "",
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              qty,
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "Rs.${price.toStringAsFixed(2)}",
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "Rs.${amount.toStringAsFixed(2)}",
                              textAlign:
                              pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Divider(),
                  ],
                );
              },
            ),
            pw.SizedBox(height: 15),
            pw.Row(
              mainAxisAlignment:
              pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  "Subtotal: ",
                ),
                pw.Text(
                  "Rs.$totalAmount",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment:
              pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  "Discount: Rs.0.00",
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment:
              pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  "Total Amount: ",
                  style: pw.TextStyle(
                    fontSize: 17,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  "Rs.$totalAmount",
                  style: pw.TextStyle(
                    fontSize: 17,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Text(
              "Payment Method: ${paymentMethod.toUpperCase()}",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Text(
                "Thank you for shopping with us!",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      name: billNo,
      onLayout: (
          PdfPageFormat format,
          ) async {
        return pdf.save();
      },
    );
  }
}
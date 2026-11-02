import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retailprostaff/viewmodel/addtobill_viewmodel.dart';
import 'Paymentpage.dart';

class Addpbill extends StatefulWidget {
  const Addpbill({
    super.key,
  });

  @override
  State<Addpbill> createState() =>
      _AddpbillState();
}

class _AddpbillState extends State<Addpbill> {
  void cusstomerdetails() {
    var provider =
    Provider.of<AddtobillViewmodel>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "customer details",
          ),
          content: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              TextField(
                controller:
                provider.cusname,
                decoration:
                InputDecoration(
                  labelText:
                  "customer name",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller:
                provider.cusnum,
                keyboardType:
                TextInputType.phone,
                maxLength: 10,
                decoration:
                InputDecoration(
                  labelText:
                  "customer mob",
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: Text(
                "skip",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (provider
                    .cusname
                    .text
                    .isNotEmpty &&
                    provider
                        .cusnum
                        .text
                        .isNotEmpty) {
                  Navigator.pop(
                    context,
                  );
                }
              },
              child: Text(
                "Continue",
              ),
            ),
          ],
        );
      },
    );
  }

  void kgQuantityDialog(
      int index,
      Map<String, dynamic> item,
      AddtobillViewmodel provider,
      ) {
    if (!provider.isKg(
      item['unit'].toString(),
    )) {
      return;
    }

    TextEditingController controller =
    TextEditingController(
      text: provider.formatCartQty(
        item['qty'],
        item['unit'].toString(),
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Change Quantity",
          ),
          content: TextField(
            controller: controller,
            keyboardType:
            TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration:
            InputDecoration(
              labelText: "Quantity",
              hintText: "Example: 0.5",
              suffixText: "kg",
              border:
              OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                double qty =
                    double.tryParse(
                      controller
                          .text
                          .trim(),
                    ) ??
                        0.0;

                bool changed =
                provider
                    .changeKgQty(
                  index,
                  qty,
                );

                if (!changed) {
                  double stock =
                      double.tryParse(
                        item['stock']
                            .toString(),
                      ) ??
                          0.0;

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Only ${provider.formatStock(stock, item['unit'].toString())} ${item['unit']} available",
                      ),
                    ),
                  );

                  return;
                }

                Navigator.pop(
                  context,
                );
              },
              child: Text(
                "Update",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback(
          (_) {
        cusstomerdetails();
      },
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Consumer<
        AddtobillViewmodel>(
      builder: (
          context,
          value,
          child,
          ) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor:
            Colors.blue,
            title: Text(
              "create a bill",
            ),
          ),
          body: value.loading
              ? Center(
            child:
            CircularProgressIndicator(),
          )
              : SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding:
                  EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: TextField(
                    onChanged:
                        (search) {
                      value
                          .searchProduct(
                        search,
                      );
                    },
                    decoration:
                    InputDecoration(
                      prefixIcon:
                      Icon(
                        Icons.search,
                      ),
                      hintText:
                      "search product name",
                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          30,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 210,
                  child:
                  ListView.builder(
                    itemCount: value
                        .filteredProducts
                        .length,
                    scrollDirection:
                    Axis.horizontal,
                    itemBuilder: (
                        context,
                        index,
                        ) {
                      final snap =
                      value.filteredProducts[
                      index];

                      var data =
                      snap.data()
                      as Map<
                          String,
                          dynamic>;

                      String image =
                          data['pimage']
                              ?.toString() ??
                              "";

                      double stock =
                          double.tryParse(
                            data['pquantity']
                                ?.toString() ??
                                "0",
                          ) ??
                              0.0;

                      String unit =
                          data['punits']
                              ?.toString() ??
                              "";

                      bool outOfStock =
                      value
                          .isOutOfStock(
                        stock,
                      );

                      return Padding(
                        padding:
                        EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child:
                        Container(
                          width: 160,
                          decoration:
                          BoxDecoration(
                            color: outOfStock
                                ? Colors
                                .red
                                .shade50
                                : Colors
                                .lightGreen
                                .shade100,
                            borderRadius:
                            BorderRadius
                                .circular(
                              15,
                            ),
                            border:
                            Border.all(
                              color: outOfStock
                                  ? Colors
                                  .red
                                  .shade200
                                  : Colors
                                  .orange
                                  .shade100,
                            ),
                          ),
                          child:
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Container(
                                height:
                                80,
                                width:
                                double
                                    .infinity,
                                decoration:
                                BoxDecoration(
                                  color: Colors
                                      .blue
                                      .shade50,
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    10,
                                  ),
                                ),
                                child:
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    10,
                                  ),
                                  child:
                                  Stack(
                                    fit: StackFit
                                        .expand,
                                    children: [
                                      image.isEmpty
                                          ? Icon(
                                        Icons.inventory_2,
                                        size: 45,
                                      )
                                          : Image.network(
                                        image,
                                        key: ValueKey(
                                          image,
                                        ),
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                            ) {
                                          return Icon(
                                            Icons.inventory_2,
                                            size: 45,
                                          );
                                        },
                                      ),
                                      Align(
                                        alignment:
                                        Alignment.bottomCenter,
                                        child:
                                        Container(
                                          width:
                                          double.infinity,
                                          color:
                                          Colors.black54,
                                          padding:
                                          EdgeInsets.all(
                                            3,
                                          ),
                                          child:
                                          Text(
                                            snap['pname'].toString(),
                                            textAlign:
                                            TextAlign.center,
                                            style:
                                            TextStyle(
                                              color:
                                              Colors.white,
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize:
                                              14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                    10,
                                  ),
                                  Text(
                                    snap['pselling price']
                                        .toString(),
                                    style:
                                    TextStyle(
                                      fontSize:
                                      18,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "/$unit",
                                    style:
                                    TextStyle(
                                      fontSize:
                                      18,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding:
                                EdgeInsets.only(
                                  left: 10,
                                ),
                                child:
                                Text(
                                  outOfStock
                                      ? "Out of stock"
                                      : "Stock: ${value.formatStock(stock, unit)} $unit",
                                  style:
                                  TextStyle(
                                    color: outOfStock
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                    10,
                                  ),
                                  Text(
                                    outOfStock
                                        ? "Unavailable"
                                        : "in stock",
                                    style:
                                    TextStyle(
                                      color: outOfStock
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  CircleAvatar(
                                    backgroundColor:
                                    outOfStock
                                        ? Colors.grey
                                        : Colors.blue,
                                    child:
                                    IconButton(
                                      onPressed:
                                      outOfStock
                                          ? null
                                          : () {
                                        bool added =
                                        value.addtocart(
                                          snap.id,
                                          snap['pname'].toString(),
                                          snap['pselling price'].toString(),
                                          unit,
                                          snap['pmrp'].toString(),
                                          stock,
                                        );

                                        if (!added) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Only ${value.formatStock(stock, unit)} $unit available",
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      icon:
                                      Icon(
                                        outOfStock
                                            ? Icons.block
                                            : Icons.add,
                                        color:
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                    10,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  elevation: 1,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "customer",
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed:
                            () {
                          showDialog(
                            context:
                            context,
                            builder:
                                (context) {
                              return AlertDialog(
                                title:
                                Text(
                                  "select customer",
                                ),
                                content:
                                Column(
                                  mainAxisSize:
                                  MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading:
                                      Icon(
                                        Icons.person,
                                      ),
                                      title:
                                      Text(
                                        "walk in customer",
                                      ),
                                      onTap:
                                          () {
                                        value.changeCustomer(
                                          "walk in customer",
                                        );

                                        Navigator.pop(
                                          context,
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading:
                                      Icon(
                                        Icons.person,
                                      ),
                                      title:
                                      Text(
                                        "Regular customer",
                                      ),
                                      onTap:
                                          () {
                                        value.changeCustomer(
                                          "Regular customer",
                                        );

                                        Navigator.pop(
                                          context,
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading:
                                      Icon(
                                        Icons.person_add,
                                      ),
                                      title:
                                      Text(
                                        "Add new customer",
                                      ),
                                      onTap:
                                          () {
                                        Navigator.pop(
                                          context,
                                        );

                                        cusstomerdetails();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          value
                              .selectedcustomer,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "billing items (${value.cart.length})",
                      style:
                      TextStyle(
                        fontSize:
                        22,
                        fontWeight:
                        FontWeight
                            .bold,
                      ),
                    ),
                    Spacer(),
                    TextButton.icon(
                      onPressed:
                      value.cart
                          .isEmpty
                          ? null
                          : value
                          .clearcart,
                      icon: Icon(
                        Icons.delete,
                        color:
                        Colors.red,
                      ),
                      label: Text(
                        "clear cart",
                        style:
                        TextStyle(
                          color:
                          Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics:
                  NeverScrollableScrollPhysics(),
                  itemCount:
                  value.cart.length,
                  itemBuilder: (
                      context,
                      index,
                      ) {
                    final item =
                    value.cart[
                    index];

                    double price =
                        double.tryParse(
                          item['price']
                              .toString(),
                        ) ??
                            0.0;

                    double qty =
                        double.tryParse(
                          item['qty']
                              .toString(),
                        ) ??
                            0.0;

                    double stock =
                        double.tryParse(
                          item['stock']
                              .toString(),
                        ) ??
                            0.0;

                    double amount =
                        price * qty;

                    String unit =
                    item['unit']
                        .toString();

                    return Padding(
                      padding:
                      EdgeInsets.only(
                        top: 5,
                      ),
                      child:
                      Container(
                        decoration:
                        BoxDecoration(
                          color: Colors
                              .blue
                              .shade50,
                          borderRadius:
                          BorderRadius
                              .circular(
                            15,
                          ),
                          border:
                          Border.all(
                            color: Colors
                                .black,
                          ),
                        ),
                        child:
                        Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius:
                                  20,
                                  backgroundColor:
                                  Colors.blue.shade50,
                                  child:
                                  Text(
                                    "${index + 1}",
                                    style:
                                    TextStyle(
                                      color:
                                      Colors.blue,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                  10,
                                ),
                                Expanded(
                                  child:
                                  Text(
                                    item['name']
                                        .toString(),
                                    style:
                                    TextStyle(
                                      fontSize:
                                      20,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed:
                                      () {
                                    value.itemdelete(
                                      index,
                                    );
                                  },
                                  icon:
                                  Icon(
                                    Icons.delete,
                                    color:
                                    Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                              EdgeInsets.symmetric(
                                horizontal:
                                10,
                              ),
                              child:
                              Align(
                                alignment:
                                Alignment.centerRight,
                                child:
                                Text(
                                  "Available: ${value.formatStock(stock, unit)} $unit",
                                  style:
                                  TextStyle(
                                    color:
                                    Colors.green,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                              10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                        EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child:
                                        Text(
                                          "Mrp",
                                          style:
                                          TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child:
                                        Text(
                                          "₹${item['mrp']}",
                                          style:
                                          TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize:
                                            18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Selling Price",
                                        style:
                                        TextStyle(
                                          fontSize:
                                          16,
                                        ),
                                      ),
                                      Text(
                                        "₹${item['price']}",
                                        style:
                                        TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize:
                                          18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child:
                                  Column(
                                    children: [
                                      Text(
                                        "Qty",
                                        style:
                                        TextStyle(
                                          fontSize:
                                          18,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                        5,
                                      ),
                                      Container(
                                        height:
                                        35,
                                        decoration:
                                        BoxDecoration(
                                          color:
                                          Colors.green.shade100,
                                          borderRadius:
                                          BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child:
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              onTap:
                                                  () {
                                                value.decreseqty(
                                                  index,
                                                );
                                              },
                                              child:
                                              Icon(
                                                Icons.remove,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap:
                                                  () {
                                                if (value.isKg(
                                                  unit,
                                                )) {
                                                  kgQuantityDialog(
                                                    index,
                                                    item,
                                                    value,
                                                  );
                                                }
                                              },
                                              child:
                                              Text(
                                                value.formatCartQty(
                                                  item['qty'],
                                                  unit,
                                                ),
                                                style:
                                                TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap:
                                                  () {
                                                bool increased =
                                                value.increseqty(
                                                  index,
                                                );

                                                if (!increased) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content:
                                                      Text(
                                                        "Only ${value.formatStock(stock, unit)} $unit available",
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child:
                                              Icon(
                                                Icons.add,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child:
                                  Column(
                                    children: [
                                      Text(
                                        "Amount",
                                        style:
                                        TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize:
                                          18,
                                        ),
                                      ),
                                      Text(
                                        "₹${amount.toStringAsFixed(2)}",
                                        style:
                                        TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize:
                                          18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height:
                              10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                  EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [
                      Text(
                        "Total Amount",
                        style:
                        TextStyle(
                          fontSize:
                          20,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                      Text(
                        "₹${value.totalAmount.toStringAsFixed(2)}",
                        style:
                        TextStyle(
                          fontSize:
                          22,
                          fontWeight:
                          FontWeight
                              .bold,
                          color:
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Center(
                  child:
                  ElevatedButton
                      .icon(
                    style:
                    ButtonStyle(
                      backgroundColor:
                      WidgetStatePropertyAll(
                        Colors.blue,
                      ),
                      foregroundColor:
                      WidgetStatePropertyAll(
                        Colors.white,
                      ),
                      padding:
                      WidgetStatePropertyAll(
                        EdgeInsets.symmetric(
                          horizontal:
                          25,
                          vertical:
                          15,
                        ),
                      ),
                    ),
                    onPressed: value
                        .cart
                        .isEmpty ||
                        value
                            .generatingBill
                        ? null
                        : () async {
                      String?
                      billNo =
                      await value
                          .generateBill();

                      if (!context
                          .mounted) {
                        return;
                      }

                      if (billNo ==
                          null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content:
                            Text(
                              "Unable to generate bill",
                            ),
                          ),
                        );

                        return;
                      }

                      double
                      totalAmount =
                          value.totalAmount;

                      List<
                          Map<String,
                              dynamic>>
                      billCart =
                      value
                          .cart
                          .map(
                            (item) => Map<
                            String,
                            dynamic>.from(
                          item,
                        ),
                      )
                          .toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                              Payme(
                                billNo:
                                billNo,
                                customerName: value
                                    .cusname
                                    .text
                                    .trim(),
                                customerMobile: value
                                    .cusnum
                                    .text
                                    .trim(),
                                cart:
                                billCart,
                                totalAmount:
                                totalAmount,
                              ),
                        ),
                      );
                    },
                    icon: value
                        .generatingBill
                        ? SizedBox(
                      height:
                      18,
                      width:
                      18,
                      child:
                      CircularProgressIndicator(
                        strokeWidth:
                        2,
                        color:
                        Colors.white,
                      ),
                    )
                        : Icon(
                      Icons
                          .receipt_long,
                    ),
                    label: Text(
                      value.generatingBill
                          ? "Generating..."
                          : "Generate Bill",
                      style:
                      TextStyle(
                        fontSize:
                        17,
                        fontWeight:
                        FontWeight
                            .bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/addtobill_viewmodel.dart';
import 'Paymen.dart';

class Addpbill extends StatefulWidget {
  Addpbill({
    super.key,
  });

  @override
  State<Addpbill> createState() => _AddpbillState();
}

class _AddpbillState extends State<Addpbill> {
  void cusstomerdetails() {
    var provider = Provider.of<AddtobillViewmodel>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (
          context,
          ) => AlertDialog(
        title: Text(
          "customer details",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: provider.cusname,
              decoration: InputDecoration(
                labelText: "customer name",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: provider.cusnum,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: "customer mob",
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
              if (provider.cusname.text.isNotEmpty &&
                  provider.cusnum.text.isNotEmpty) {
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_,) => cusstomerdetails(),);
  }
  @override
  Widget build(
      BuildContext context,
      ) {
    return Consumer<AddtobillViewmodel>(
      builder: (context, value, child,) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "create a bill",
          ),
        ),
        body: value.loading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextField(
                  onChanged: (
                      search,
                      ) => value.searchProduct(
                    search,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    hintText: "search product name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
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
                child: ListView.builder(
                  itemCount: value.filteredProducts.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (
                      context,
                      index,
                      ) {
                    final snap = value.filteredProducts[index];
                    var data = snap.data() as Map<String, dynamic>;
                    String image = data['pimage']?.toString() ?? "";

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Container(
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.shade100,
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                          border: Border.all(
                            color: Colors.orange.shade100,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    image.isEmpty
                                        ? Icon(
                                      Icons.inventory_2,
                                      size: 45,
                                    )
                                        : Image.network(
                                      image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                          ) => Icon(
                                        Icons.inventory_2,
                                        size: 45,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.black54,
                                        padding: EdgeInsets.all(
                                          3,
                                        ),
                                        child: Text(
                                          snap['pname'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
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
                                  width: 10,
                                ),
                                Text(
                                  snap['pselling price'].toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "/${snap['punits']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "in stock",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: IconButton(
                                    onPressed: () {
                                      value.addtocart(
                                        snap.id,
                                        snap['pname'],
                                        snap['pselling price'].toString(),
                                        snap['punits'].toString(),
                                        snap['pmrp'].toString(),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (
                              context,
                              ) => AlertDialog(
                            title: Text(
                              "select customer ",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.person,
                                  ),
                                  title: Text(
                                    "walk in customer",
                                  ),
                                  onTap: () {
                                    value.changeCustomer(
                                      "walk in customer",
                                    );
                                    Navigator.pop(
                                      context,
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.person,
                                  ),
                                  title: Text(
                                    "Regular customer",
                                  ),
                                  onTap: () {
                                    value.changeCustomer(
                                      "Regular customer",
                                    );
                                    Navigator.pop(
                                      context,
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.person,
                                  ),
                                  title: Text(
                                    "Add new customer",
                                  ),
                                  onTap: () {
                                    Navigator.pop(
                                      context,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        value.selectedcustomer,
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
                    "billing items(${value.cart.length})",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  TextButton.icon(
                    onPressed: value.cart.isEmpty ? null : value.clearcart,
                    icon: Icon(
                      Icons.delete,
                    ),
                    label: Text(
                      "clear cart",
                      style: TextStyle(
                        color: Colors.red,
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
                physics: NeverScrollableScrollPhysics(),
                itemCount: value.cart.length,
                itemBuilder: (
                    context,
                    index,
                    ) {
                  final item = value.cart[index];
                  double price = double.tryParse(
                    item['price'].toString(),
                  ) ?? 0;
                  int qty = int.tryParse(
                    item['qty'].toString(),
                  ) ?? 0;
                  double amount = price * qty;

                  return Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.blue.shade50,
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  item['name'].toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  value.itemdelete(
                                    index,
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                      ),
                                      child: Text(
                                        "Mrp",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                      ),
                                      child: Text(
                                        item['mrp'].toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Selling Price",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      item['price'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Qty",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: Container(
                                        height: 35,
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          color: Colors.green.shade100,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                value.decreseqty(
                                                  index,
                                                );
                                              },
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 17,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                item['qty'].toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                value.increseqty(
                                                  index,
                                                );
                                              },
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.add,
                                                  size: 17,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Amount",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "₹$amount",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
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
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.blue,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      Colors.white,
                    ),
                  ),
                  onPressed: value.cart.isEmpty
                      ? null
                      : () async {
                    double totalAmount = value.totalAmount;
                    String billNo = await value.getBillNumber();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (
                            context,
                            ) => Payme(
                          billNo: billNo,
                          customerName: value.cusname.text,
                          customerMobile: value.cusnum.text,
                          cart: value.cart,
                          totalAmount: totalAmount,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Generate bill',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:retailprostaff/view/sales/viewpastbill.dart';
import 'Addtobill_view.dart';
import 'Detailbill.dart';
class Sale extends StatefulWidget {
  const Sale({super.key});

  @override
  State<Sale> createState() => _SaleState();
}

class _SaleState extends State<Sale> {
  final CollectionReference sales = FirebaseFirestore.instance.collection('sales');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("Sales"),
          backgroundColor: Colors.blue
      ),
      body: StreamBuilder(
          stream: sales.orderBy('date',descending: true).snapshots(),
          builder: (context,shapshort){
            if(shapshort.hasData){
              var docs = shapshort.data!.docs;
              double tSales = 0;
              double tCashSales = 0;
              for (var bill in docs) {
                tSales = tSales +
                    double.parse(bill['totalAmount'].toString());
                   if (bill['paymentMethod'] == "Cash") {
                    tCashSales = tCashSales +
                  double.parse(bill['totalAmount'].toString());
                }
                 }
              double averageBill = 0;

              if (docs.isNotEmpty) {
                averageBill = tSales / docs.length;
              }
              return
                ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child:Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue.shade100,
                                      child: Icon(Icons.shopping_cart,color:Colors.blue,),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Total sales",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),),
                                    Text("$tSales",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),),
                                  ],
                                ),
                              ) ,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child:Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.orange.shade100,
                                      child: Icon(Icons.receipt,color:Colors.orange,),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Total bills",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),),
                                    Text(docs.length.toString(),style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),),
                                  ],

                                ),
                              ) ,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child:Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.green.shade100,
                                      child: Icon(Icons.people,color:Colors.green,),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Cash sale",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),),
                                    Text("$tCashSales",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),),
                                  ],

                                ),
                              ) ,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child:Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.red.shade100,
                                      child: Icon(Icons.wallet,color:Colors.red,),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Avg bill value",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),),
                                    Text("₹${averageBill.toStringAsFixed(2)}",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                                    ),),
                                  ],

                                ),
                              ) ,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.blue,
                            child:ListTile(
                              title:Text("create new bills", maxLines: 2, style: TextStyle(
                                color:Colors.white,

                              ) ),
                              leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child:IconButton(
                                    onPressed:(){
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>Addpbill()));
                                    },
                                    icon:Icon(Icons.add),color: Colors.black,)
                              ),
                              // subtitle:Text("add products and generate bills"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>Viewpbills()));
                            },
                            child: Card(
                              color: Colors.greenAccent,
                              child:
                              ListTile(
                                trailing:Icon(Icons.arrow_forward_ios,),
                                title: Text("view all bills",maxLines: 2,),
                                leading: CircleAvatar(
                                  child: Icon((Icons.receipt),color: Colors.black,),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text("Recent Sales",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          )),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount:docs.length > 3 ? 3 : docs.length,
                        itemBuilder: (context,index){
                          final snap=docs[index];
                          return
                            Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: Card(
                                elevation: 5,
                                color: Colors.green.shade100,
                                child:
                                Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    ListTile(
                                        title: Text(snap['billno'],style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18
                                        ),),
                                        leading: CircleAvatar(
                                          radius: 20,
                                          child: Icon(Icons.receipt,color: Colors.blue,),
                                          backgroundColor: Colors.blue.shade100,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                Icon(Icons.inventory_2),
                                                SizedBox(width: 5,),
                                                Text("Items: ${snap['items'].length}"),
                                                Text(" | "),
                                                Text(snap['paymentMethod']),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                            onPressed: (){
                                              Navigator.push(context,MaterialPageRoute(
                                                  builder: (context)=>Detailpbill(snap: snap,)));

                                            },
                                            icon: Icon(Icons.arrow_forward_ios))

                                    ),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            );
                        }),
                  ],
                );
            }else{
              return
                  CircularProgressIndicator();
            }

    })
    );
  }
}

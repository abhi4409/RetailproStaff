import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Detailbill.dart';
class Viewpbills extends StatefulWidget {
  const Viewpbills({super.key});

  @override
  State<Viewpbills> createState() => _ViewpbillsState();
}

class _ViewpbillsState extends State<Viewpbills> {
  final CollectionReference sales = FirebaseFirestore.instance.collection('sales');
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: Text("view past bills"),
          actions: [
            Icon(Icons.receipt),
            SizedBox(width: 5,)
          ],
        ),
        body:StreamBuilder(stream: sales.snapshots(),
            builder: (context,snapshort){
              if(snapshort.hasData){
                var docs = snapshort.data!.docs;
                var filteredBills = docs.where((doc) {
                  String billNo =
                  doc['billno'].toString().toLowerCase();
                  return billNo.contains(
                    searchText.toLowerCase(),
                  );
                }).toList();
                return Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child:SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                            });
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText:" Search bill no",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)
                              )
                          ),
                        ),
                        SizedBox(height: 20,),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredBills.length,
                            itemBuilder: (context,index){
                              final snap = filteredBills[index];
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
                                                    Text("${snap['items'].length} items | "),
                                                    Text(snap['paymentMethod']),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            trailing:IconButton(onPressed: (){
                                              Navigator.push(context,MaterialPageRoute(
                                                  builder: (context)=>Detailpbill(snap: snap)));
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
                    ),
                  ),
                );
              }else{
                return CircularProgressIndicator();
              }

            })
    );
  }
}


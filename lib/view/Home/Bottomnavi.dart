import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retailprostaff/view/sales/Sales.dart';

import '../Orders/Orders.dart';
import '../Products/Products.dart';
import 'Home.dart';
class Bottomnaviga extends StatefulWidget {
  const Bottomnaviga({super.key});

  @override
  State<Bottomnaviga> createState() => _BottomnavigaState();
}

class _BottomnavigaState extends State<Bottomnaviga> {
  int Selected= 0;
  List pages=[
    Hom(),
    Sale(),
    Online_orders(),
    Proda(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  BottomNavigationBar(
        currentIndex: Selected,
          onTap: (index){
          setState(() {
            Selected=index;
          });
          },
          backgroundColor: Colors.black,
          items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
        label:"Home ",
        backgroundColor: Colors.black),
        BottomNavigationBarItem(icon: Icon(Icons.inventory),
        label: "sales",
            backgroundColor: Colors.black),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),
              label: "Orders",
              backgroundColor: Colors.black
            ),

        BottomNavigationBarItem(icon: Icon(Icons.inventory),
        label: "products",
            backgroundColor: Colors.black),
      ]),
      body: pages[Selected],
    );
  }
}

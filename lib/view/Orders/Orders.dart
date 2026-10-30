import 'package:flutter/material.dart';
import '../Ordertabs/Accepted.dart';
import '../Ordertabs/Completed.dart';
import '../Ordertabs/New.dart';
import '../Ordertabs/Ready.dart';

class Online_orders extends StatefulWidget {
  const Online_orders({
    super.key,
  });

  @override
  State<Online_orders> createState() => _Online_ordersState();
}

class _Online_ordersState extends State<Online_orders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(
            "Online Orders",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            tabs: const [
              Tab(
                text: "New",
              ),
              Tab(
                text: "Accepted",
              ),
              Tab(
                text: "Ready",
              ),
              Tab(
                text: "Completed",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Neworder(),
            Accep(),
            Readyorder(),
            Completee(),
          ],
        ),
      ),
    );
  }
}
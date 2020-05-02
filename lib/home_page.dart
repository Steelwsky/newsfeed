import 'package:flutter/material.dart';
import 'package:newsfeed/main.dart';

import 'app_bar.dart';
import 'bottom_nav_bar.dart';
import 'drawer.dart';
import 'page_view.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({this.myStorage});

  final MyStorageConcept myStorage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: MyPageView(myStorage: widget.myStorage),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}

import 'package:flutter/material.dart';

import 'app_bar.dart';
import 'bottom_nav_bar.dart';
import 'page_view.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: MyPageView(),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}

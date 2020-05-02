import 'package:flutter/material.dart';

import 'app_bar.dart';
import 'page_view.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return Scaffold(
      appBar: MyAppBar(),
      body: MyPageView(pageController: pageController),
    );
  }
}

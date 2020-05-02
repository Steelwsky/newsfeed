import 'package:flutter/material.dart';

import 'my_page_view.dart';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar title'),
      ),
      body: MyPageView(pageController: pageController),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_bar.dart';
import 'bottom_nav_bar.dart';
import 'controller/common_news_controller.dart';
import 'drawer.dart';
import 'history_news_page.dart';
import 'latest_news_page.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myPageController = Provider.of<MyPageController>(context);
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: PageView(
        controller: myPageController.pageController,
        onPageChanged: (pageIndex) => myPageController.pageSwipeChange(pageIndex),
        children: <Widget>[
          LatestNewsPage(),
          const HistoryNewsPage(),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/common_news_controller.dart';
import 'history_news_page.dart';
import 'latest_news_page.dart';

class MyPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myPageController = Provider.of<MyPageController>(context);
    return PageView(
      controller: myPageController.pageController,
      onPageChanged: (pageIndex) {
        myPageController.pageSwipeChange(pageIndex);
      },
      children: <Widget>[LatestNewsPage(), HistoryNewsPage()],
    );
  }
}

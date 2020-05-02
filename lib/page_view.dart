import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/common_news_controller.dart';
import 'history_news_page.dart';
import 'latest_news_page.dart';

class MyPageView extends StatelessWidget {
  MyPageView({this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final myPageController = Provider.of<MyPageController>(context);
    return PageView(
      controller: pageController,
      onPageChanged: (pageIndex) {
        myPageController.pageChange(pageIndex);
      },
      children: <Widget>[LatestNewsPage(), HistoryNewsPage()],
    );
  }
}

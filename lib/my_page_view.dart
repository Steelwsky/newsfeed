import 'package:flutter/material.dart';

import 'history_news_page.dart';
import 'latest_news_page.dart';

class MyPageView extends StatelessWidget {
  MyPageView({this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      onPageChanged: (pageIndex) {
        //todo
      },
      children: <Widget>[
        LatestNewsPage(),
        HistoryNewsPage()
      ],
    );
  }
}





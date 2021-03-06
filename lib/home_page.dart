import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsfeed/pages/search_page.dart';
import 'package:newsfeed/search_bloc/search_bloc.dart';
import 'package:provider/provider.dart';

import 'controller/common_news_controller.dart';
import 'controller/page_controller.dart';
import 'pages/history_news_page.dart';
import 'pages/latest_news_page.dart';
import 'widgets/app_bar.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/drawer.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myPageController = Provider.of<MyPageController>(context);
    final newsController = Provider.of<NewsController>(context);
    return BlocProvider(
        create: (context) => SearchBloc(newsController: newsController),
        child: Scaffold(
          appBar: MyAppBar(),
          drawer: MyDrawer(),
          body: PageView(
            controller: myPageController.pageController,
            onPageChanged: (pageIndex) => myPageController.pageSwipeChange(pageIndex),
            children: <Widget>[
              LatestNewsPage(),
              const HistoryNewsPage(),
              SearchPage(),
            ],
          ),
          bottomNavigationBar: MyBottomNavigationBar(),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:newsfeed/strings.dart';
import 'package:provider/provider.dart';

import 'controller/common_news_controller.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final newsController = Provider.of<NewsController>(context);
    final myPageController = Provider.of<MyPageController>(context);
    return ValueListenableBuilder(
        valueListenable: myPageController.pageStateNotifier,
        builder: (_, pageState, __) {
          return AppBar(
            title: pageState == 0
                ? AppBarText()
                : Text(
              HISTORY,
              key: ValueKey('HistoryAppBar'),
            ),
            actions: <Widget>[
              IconButton(
                key: ValueKey('deleteIcon'),
                icon: Icon(Icons.delete),
                onPressed: newsController.deleteHistory,
              ),
            ],
          );
        });
  }
}

class AppBarText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsController = Provider.of<NewsController>(context);
    return ValueListenableBuilder<RssDataSourceModel>(
        valueListenable: newsController.rssDataSourceNotifier,
        builder: (_, rssDataSourceState, __) {
          return Text(
            '$LATEST - ${rssDataSourceState.shortName}',
            key: ValueKey('LatestAppBar'),
          );
        });
  }
}

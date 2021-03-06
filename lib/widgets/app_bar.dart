import 'package:flutter/material.dart';
import 'package:newsfeed/constants/strings.dart';
import 'package:newsfeed/models/rss_data_source_model.dart';
import 'package:newsfeed/widgets/search_app_bar.dart';
import 'package:provider/provider.dart';

import '../controller/common_news_controller.dart';
import '../controller/page_controller.dart';

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
          return pageState != 2 //TODO very bad code here
              ? AppBar(
                  title: pageState == 0 //TODO very bad code here
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
                )
              : SearchAppBar();
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



import 'package:flutter/material.dart';
import 'package:newsfeed/strings.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';

import 'controller/common_news_controller.dart';

class LatestNewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myNewsController = Provider.of<NewsController>(context);
    return ValueListenableBuilder<RssFeed>(
        valueListenable: myNewsController.rssFeedNotifier,
        builder: (_, rssFeed, __) {
          return RefreshIndicator(
              key: ValueKey('latestNewsPage'),
              onRefresh: myNewsController.fetchNews,
              child: rssFeed.items == null
                  ? EmptyList()
                  : ListView(
                  key: PageStorageKey('latest'),
                  children: rssFeed.items
                      .map(
                        (i) =>
                        ListTile(
                          key: ValueKey('item${rssFeed.items.indexOf(i)}'),
                          title: Text(
                            i.title,
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            i.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Icon(Icons.bookmark_border, size: 24, color: Colors.amber),
                          onTap: () {},
                        ),
                  )
                      .toList()));
        });
  }
}

class EmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text(
              PULL_DOWN_TO_UPDATE,
              key: Key('empty'),
              style: TextStyle(fontSize: 18),
            ),
          ),
        )
      ],
    );
  }
}

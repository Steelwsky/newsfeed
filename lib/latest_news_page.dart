import 'package:flutter/material.dart';
import 'package:newsfeed/strings.dart';
import 'package:provider/provider.dart';

import 'controller/common_news_controller.dart';
import 'selected_news_page.dart';

class LatestNewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myNewsController = Provider.of<NewsController>(context);
    return ValueListenableBuilder<Iterable<FeedRssItem>>(
        valueListenable: myNewsController.preparedRssFeedNotifier,
        builder: (_, preparedRssFeed, __) {
          return RefreshIndicator(
              key: ValueKey('latestNewsPage'),
              onRefresh: myNewsController.fetchNews,
              child: preparedRssFeed.isEmpty
                  ? EmptyList()
                  : ListView(
                  key: PageStorageKey('latest'),
                  children: preparedRssFeed.toList()
                      .map(
                        (i) =>
                        ListTile(
                          key: ValueKey('item${preparedRssFeed.toList().indexOf(i)}'),
                          title: Text(
                            i.item.title,
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            i.item.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Icon(i.isViewed ? Icons.bookmark : Icons.bookmark_border,
                              size: 24, color: Colors.amber),
                          onTap: () {
                            myNewsController.addToHistory(item: i.item);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => SelectedNewsPage(rssItem: i.item)));
                          },
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
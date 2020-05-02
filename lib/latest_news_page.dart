import 'package:flutter/material.dart';
import 'package:newsfeed/strings.dart';
import 'package:provider/provider.dart';

import 'controller/common_news_controller.dart';
import 'selected_news_page.dart';

class LatestNewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myNewsController = Provider.of<NewsController>(context);
    return ValueListenableBuilder<PreparedFeed>(
        valueListenable: myNewsController.preparedRssFeedNotifier,
        builder: (_, preparedRssFeed, __) {
          return RefreshIndicator(
              key: ValueKey('latestNewsPage'),
              onRefresh: myNewsController.fetchNews,
              child: preparedRssFeed.items == null
                  ? EmptyList()
                  : ListView(
                  key: PageStorageKey('latest'),
                  children: preparedRssFeed.items
                      .map(
                        (i) =>
                        ListTile(
                          key: ValueKey('item${preparedRssFeed.items.indexOf(i)}'),
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
                          trailing: Icon(
                              i.isViewed ? Icons.bookmark : Icons.bookmark_border, size: 24, color: Colors.amber),
                          onTap: () {
                            myNewsController.addToHistory(item: i.item, position: preparedRssFeed.items.indexOf(i));
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

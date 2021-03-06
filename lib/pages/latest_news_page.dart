import 'package:flutter/material.dart';
import 'package:newsfeed/constants/strings.dart';
import 'package:newsfeed/models/feed_rss_item_model.dart';
import 'package:provider/provider.dart';

import '../controller/common_news_controller.dart';
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
                  ? EmptyListForLatest()
                  : LatestListNewsWidget(
                      myNewsController: myNewsController,
                      preparedRssFeed: preparedRssFeed,
                    ));
        });
  }
}

class LatestListNewsWidget extends StatelessWidget {
  const LatestListNewsWidget({
    Key key,
    @required this.myNewsController,
    @required this.preparedRssFeed,
  }) : super(key: key);

  final NewsController myNewsController;
  final Iterable<FeedRssItem> preparedRssFeed;

  @override
  Widget build(BuildContext context) {
    return ListView(
        key: PageStorageKey('latest'),
        children: preparedRssFeed
            .toList()
            .map(
              (i) => ListTile(
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
                trailing: Icon(i.isViewed ? Icons.bookmark : Icons.bookmark_border, size: 24, color: Colors.amber),
                onTap: () {
                  myNewsController.addToHistory(item: i.item);
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => SelectedNewsPage(rssItem: i.item)));
                },
              ),
            )
            .toList());
  }
}

class EmptyListForLatest extends StatelessWidget {
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

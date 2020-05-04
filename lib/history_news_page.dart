import 'package:flutter/material.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/strings.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';

import 'selected_news_page.dart';

class HistoryNewsPage extends StatelessWidget {
  const HistoryNewsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsController = Provider.of<NewsController>(context);
    return ValueListenableBuilder<Iterable<RssItem>>(
      valueListenable: newsController.historyListNotifier,
      builder: (_, history, __) {
        return history.isEmpty ? EmptyHistoryList() : MyHistory(history: history);
      },
    );
  }
}

class MyHistory extends StatelessWidget {
  MyHistory({this.history});

  final Iterable<RssItem> history;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: PageStorageKey('historyNewsPage'),
      itemCount: history.length,
      itemBuilder: (_, index) {
        final historyItem = history.elementAt(index);
        return ListTile(
          key: ValueKey('item$index'),
          title: Text(
            historyItem.title,
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Text(
            historyItem.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16),
          ),
          trailing: Icon(Icons.bookmark, size: 24, color: Colors.amber),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => SelectedNewsPage(rssItem: historyItem)));
          },
        );
      },
    );
  }
}

class EmptyHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Text(
          EMPTY_HISTORY,
          key: ValueKey('emptyHistory'),
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/main.dart';
import 'package:newsfeed/strings.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';

class HistoryNewsPage extends StatelessWidget {
  const HistoryNewsPage({Key key, this.myStorage}) : super(key: key);
  final MyStorageConcept myStorage;

  @override
  Widget build(BuildContext context) {
    final newsController = Provider.of<NewsController>(context);
    return ValueListenableBuilder<List<RssItem>>(
      valueListenable: newsController.historyListNotifier,
      builder: (_, historyState, __) {
        return historyState.isEmpty
            ? EmptyHistoryList()
            : ListView.builder(
          key: PageStorageKey('historyNewsPage'),
          itemCount: historyState.length,
          itemBuilder: (_, index) {
            final historyItem = historyState[index];
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
              onTap: () {},
            );
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

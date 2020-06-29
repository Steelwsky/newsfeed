import 'package:flutter/material.dart';
import 'package:newsfeed/constants/strings.dart';
import 'package:newsfeed/models/feed_rss_item_model.dart';
import 'package:newsfeed/models/rss_data_source_model.dart';
import 'package:uuid/uuid.dart';
import 'package:webfeed/webfeed.dart';

import '../main.dart';

class NewsController {
  NewsController({this.getRssFromUrl, this.myDatabase}) {
    historyIdsNotifier.value = myDatabase.retrieveViewedItemIds();
    print('updating history list in newsController');
    print('searchRssItems: ${searchRssItems.value}');
  }

  final GetRssFromUrl getRssFromUrl;
  final MyStorageConcept myDatabase;
  static RssDataSourcesList rssDataSourcesList = RssDataSourcesList();

  ValueNotifier<Iterable<FeedRssItem>> preparedRssFeedNotifier = ValueNotifier([]); //todo convert to BLoC

  ValueNotifier<Future<Iterable<String>>> historyIdsNotifier = ValueNotifier(Future.value([]));

  ValueNotifier<RssDataSourceModel> rssDataSourceNotifier = ValueNotifier(rssDataSourcesList.sources.first);

  ValueNotifier<RssFeed> rssFeedNotifier = ValueNotifier(null);

  ValueNotifier<List<FeedRssItem>> searchRssItems = ValueNotifier([]);

  ValueNotifier<String> queryForSearch = ValueNotifier('');

  List<RssDataSourceModel> getDataSource() => rssDataSourcesList.sources;

  void changingDataSource(DataSource source) {
    rssDataSourceNotifier.value = getDataSource()[source.index];
  }

  Future<void> fetchNews() async {
    await getRssFromUrl(rssDataSourceNotifier.value.link).then((feed) async {
      _assignUuidToItems(feed);
    });
  }

  String _getUuidFromString(String title) => Uuid().v5(title, 'UUID');

  void _assignUuidToItems(RssFeed feed) async {
    List<RssItem> myList = [];
    for (var i = 0; i < feed.items.length; i++) {
      final feedItem = feed.items[i];
      myList.add(RssItem(
          guid: _getUuidFromString(feedItem.title),
          title: feedItem.title,
          description: feedItem.description,
          link: feedItem.link));
    }
    rssFeedNotifier.value = RssFeed(items: myList);

    await checkViewedNews(rssFeedNotifier.value);
  }

  Future<void> checkViewedNews(RssFeed feed) async {
    final List<FeedRssItem> preparedFeed = [];
    for (var i = 0; i < feed.items.length; i++) {
      preparedFeed.add(FeedRssItem(item: feed.items[i], isViewed: await isNewsInHistory(uuid: feed.items[i].guid)));
    }
    preparedRssFeedNotifier.value = preparedFeed;
  }

  Future<bool> isNewsInHistory({@required String uuid}) async {
    return historyIdsNotifier.value.then((onValue) => onValue.toList().contains(uuid));
  }

  Future<void> addToHistory({RssItem item}) async {
    if (await isNewsInHistory(uuid: item.guid) == false) {
      myDatabase.addItem(item);
      historyIdsNotifier.value = myDatabase.retrieveViewedItemIds();
      preparedRssFeedNotifier.value = preparedRssFeedNotifier.value.toList().map((f) {
        if (f.item.guid == item.guid) {
          return f.copyWith(isViewed: true);
        }
        return f;
      });
    }
  }

  Future<void> deleteHistory() async {
    await myDatabase.deleteHistory();
    historyIdsNotifier.value = Future.value([]);
    if (rssFeedNotifier.value != null) {
      preparedRssFeedNotifier.value = preparedRssFeedNotifier.value.toList().map((f) => f.copyWith(isViewed: false));
    }
  }

  Stream<List<FeedRssItem>> getAll() {
    print('getAll called');
    return myDatabase.streamHistory();
  }

  Future<List<FeedRssItem>> unionLatestAndHistory() async {
    final List<FeedRssItem> listHistory = await myDatabase.streamHistory().first;
    final List<FeedRssItem> listLatest = preparedRssFeedNotifier.value.toList();
    listLatest.insertAll(listLatest.length, listHistory);
    print('union: ${listLatest.length}');
    return listLatest;
  }

  void queryForGoogle({String query}) {
    print('queryForGoogle: $query');
    queryForSearch.value = '$SEARCH_GOOGLE$query';
  }

  Future<void> findItemsBySearch(String query) async {
    print('inside findItemsBySearch');
    List<FeedRssItem> list = await unionLatestAndHistory();
    list = list.where((element) => element.item.title.toLowerCase().contains(query.toLowerCase())).toList();
    if (list.isEmpty) {
      searchRssItems.value = null;
    } else
      searchRssItems.value = list;
    print('found: ${searchRssItems.value}');
  }
}

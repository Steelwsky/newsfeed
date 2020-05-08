import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:newsfeed/strings.dart';
import 'package:uuid/uuid.dart';
import 'package:webfeed/webfeed.dart';

import '../main.dart';

enum Pages { latest, history }

class MyPageController {
  ValueNotifier<int> pageStateNotifier = ValueNotifier(Pages.latest.index);

  MyPageController({this.pageController});

  final PageController pageController;

  void pageSwipeChange(int pageIndex) {
    pageStateNotifier.value = pageIndex;
  }

  void pageNavBarChange(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    pageStateNotifier.value = pageIndex;
  }
}

class BottomNavBarItemModel {
  BottomNavBarItemModel({this.name, this.icon});

  final String name;
  final Icon icon;
}

class BottomNavBarItems {
  List<BottomNavBarItemModel> _tabs;

  BottomNavBarItems() {
    _tabs = [
      BottomNavBarItemModel(
          name: LATEST,
          icon: Icon(
            Icons.home,
          )),
      BottomNavBarItemModel(
          name: HISTORY,
          icon: Icon(
            Icons.history,
          ))
    ];
  }

  UnmodifiableListView<BottomNavBarItemModel> get tabs => UnmodifiableListView(_tabs);
}

enum DataSource { cnbc, nytimes }

class RssDataSourceModel {
  RssDataSourceModel({
    this.source,
    this.link,
    this.longName,
    this.shortName,
  });

  final DataSource source;
  final String link;
  final String longName;
  final String shortName;
}

class RssDataSourcesList {
  static List<RssDataSourceModel> _sources;

  RssDataSourcesList() {
    _sources = [
      RssDataSourceModel(
          source: DataSource.cnbc,
          link: 'https://www.cnbc.com/id/100727362/device/rss/rss.html',
          longName: 'CNBC International',
          shortName: 'CNBC'),
      RssDataSourceModel(
          source: DataSource.nytimes,
          link: 'https://www.nytimes.com/svc/collections/v1/publish/https://www.nytimes.com/section/world/rss.xml',
          longName: 'The New York Times',
          shortName: 'NY Times'),
    ];
  }

  List<RssDataSourceModel> get sources => _sources;
}

//TODO test all public functions
class NewsController {
  NewsController({this.getRssFromUrl, this.myDatabase}) {
    historyIdsNotifier.value = myDatabase.retrieveViewedItemIds(); //todo  test check if counter++
    print('updating history list in newsController');
  }

  final GetRssFromUrl getRssFromUrl;
  final MyStorageConcept myDatabase;
  static RssDataSourcesList rssDataSourcesList = RssDataSourcesList();

  ValueNotifier<Iterable<FeedRssItem>> preparedRssFeedNotifier = ValueNotifier([]);

  ValueNotifier<Future<Iterable<String>>> historyIdsNotifier = ValueNotifier(Future.value([]));

  ValueNotifier<RssDataSourceModel> rssDataSourceNotifier = ValueNotifier(rssDataSourcesList.sources.first);

  ValueNotifier<RssFeed> rssFeedNotifier = ValueNotifier(null);

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
      print(myList[i].guid);
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
//      preparedRssFeedNotifier.value = preparedRssFeedNotifier.value.toList().map((f) => f.copyWith(isViewed: true));
      checkViewedNews(rssFeedNotifier.value);
    }
  }

  Future<void> deleteHistory() async {
    await myDatabase.deleteHistory();
    historyIdsNotifier.value = Future.value([]);
    if (rssFeedNotifier.value != null) {
      preparedRssFeedNotifier.value = preparedRssFeedNotifier.value.toList().map((f) => f.copyWith(isViewed: false));
    }
  }

  Stream<List<RssItem>> getAll() {
    print('getAll called');
    return myDatabase.streamHistory();
  }
}

class FeedRssItem {
  FeedRssItem({this.item, this.isViewed});

  final RssItem item;
  final bool isViewed;

  FeedRssItem copyWith({bool isViewed}) {
    return FeedRssItem(isViewed: isViewed, item: item);
  }
}

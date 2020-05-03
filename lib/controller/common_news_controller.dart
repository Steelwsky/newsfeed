import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:newsfeed/strings.dart';
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

class NewsController {
  NewsController({this.getRssFromUrl, this.myStorage}) {
    print('updating history list in newsController');
    updateHistoryList();
  }

  final GetRssFromUrl getRssFromUrl;
  final MyStorageConcept myStorage;
  static RssDataSourcesList rssDataSourcesList = RssDataSourcesList();

  ValueNotifier<Iterable<FeedRssItem>> preparedRssFeedNotifier = ValueNotifier([]);

  ValueNotifier<Iterable<RssItem>> historyListNotifier = ValueNotifier([]);

  ValueNotifier<RssDataSourceModel> rssDataSourceNotifier = ValueNotifier(rssDataSourcesList.sources.first);

  List<RssDataSourceModel> getDataSource() => rssDataSourcesList.sources;

  void changingDataSource(DataSource source) {
    print('source index: ${source.index}');
    final dataSource = getDataSource()[source.index];
    rssDataSourceNotifier.value = dataSource;
  }

  Future<void> fetchNews({@required String link}) async {
    print('inside');
    await getRssFromUrl(link != null ? link : rssDataSourceNotifier.value.link).then((feed) {
      print('getRssFromUrl');
      checkViewedNews(feed);
    });
  }

  void checkViewedNews(RssFeed feed) {
    final List<FeedRssItem> preparedFeed = [];
    print('length: ${preparedFeed.length}');
    for (var i = 0; i < feed.items.length; i++) {
      preparedFeed.add(FeedRssItem(item: feed.items[i], isViewed: isNewsInHistory(feed.items[i])));
    }
    preparedRssFeedNotifier.value = preparedFeed;
  }

  bool isNewsInHistory(RssItem item) {
    return myStorage.isItemInHistory(item.link);
  }

  void addToHistory({RssItem item}) {
    if (isNewsInHistory(item) == false) {
      myStorage.addItem(item);
      fetchNews(link: rssDataSourceNotifier.value.link); //todo bad code here
      updateHistoryList();
//      final list = preparedRssFeedNotifier.value;
//      list[position] = FeedRssItem(item: list.elementAt(position).item); //todo Map?
//      preparedRssFeedNotifier.value = PreparedFeed(items: list);
    }
  }

//  void _markAsViewedInLatest(RssItem item) {
//    final list = preparedRssFeedNotifier.value.toList();
//  }

  void updateHistoryList() {
    historyListNotifier.value = myStorage.getAll();
  }
}

class FeedRssItem {
  FeedRssItem({this.item, this.isViewed});

  final RssItem item;
  final bool isViewed;
}
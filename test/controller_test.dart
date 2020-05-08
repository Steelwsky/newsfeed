import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/main.dart';
import 'package:uuid/uuid.dart';
import 'package:webfeed/webfeed.dart';
import 'rss_data_sample_test.dart';

void main() {
  group('NewsController', () {
    test('retrieving data source list', () {
      FakeStorage fakeStorage = FakeStorage();
      final newsController = NewsController(getRssFromUrl: (url) => Future.value(feed), myDatabase: fakeStorage);
      final rssDataSourcesList = RssDataSourcesList();

      var receivedList = newsController.getDataSource();
      expect(receivedList, rssDataSourcesList.sources);
    });

    test('data source changes', () {
      FakeStorage fakeStorage = FakeStorage();
      final newsController = NewsController(getRssFromUrl: (url) => Future.value(feed), myDatabase: fakeStorage);
      final rssDataSourcesList = RssDataSourcesList();

      newsController.rssDataSourceNotifier.value = null;

      expect(newsController.rssDataSourceNotifier.value, null);
      newsController.changingDataSource(rssDataSourcesList.sources.last.source);
      expect(newsController.rssDataSourceNotifier.value, rssDataSourcesList.sources.last);
    });

    test('checkViewedNews adds feed items to rssFeedNotifier', () async {
      FakeStorage fakeStorage = FakeStorage();
      final newsController = NewsController(getRssFromUrl: (url) => Future.value(feed), myDatabase: fakeStorage);

      var expectedFeedLength;
      newsController.preparedRssFeedNotifier.addListener(() {
        expectedFeedLength = newsController.preparedRssFeedNotifier.value.length;
        print('notification from rssFeed, ${newsController.preparedRssFeedNotifier.value.length}');
      });

      expect(expectedFeedLength, null);
      await newsController.checkViewedNews(feed);
      expect(expectedFeedLength, feed.items.length);
    });

    test('isNewsInHistory returns false', () async {
      FakeStorage fakeStorage = FakeStorage();
      final newsController = NewsController(getRssFromUrl: (url) => Future.value(feed), myDatabase: fakeStorage);

      var resultBool = await newsController.isNewsInHistory(uuid: Uuid().v5(feed.items.first.title, 'UUID'));
      expect(resultBool, false);
    });

    test('isNewsInHistory returns true', () async {
      FakeStorage fakeStorage = FakeStorage();
      final newsController = NewsController(getRssFromUrl: (url) => Future.value(feed), myDatabase: fakeStorage);

      final itemId = Uuid().v5(feed.items.first.title, 'UUID');
      fakeStorage.listOfIds.add(itemId);

      var resultBool = await newsController.isNewsInHistory(uuid: itemId);
      expect(resultBool, true);
    });

    test('item is added to storage when addToHistory is called', () async {
      FakeStorage fakeStorage = FakeStorage();
      final singleItem = [RssItem(title: '123')];
      final newsController =
          NewsController(getRssFromUrl: (url) => Future.value(RssFeed(items: singleItem)), myDatabase: fakeStorage);

      expect(fakeStorage.historyList.length, 0);
      await newsController.addToHistory(item: singleItem.first);
      expect(fakeStorage.historyList.length, 1);
    });

    test('item is added to storage when addToHistory2121 is called', () async {
      FakeStorage fakeStorage = FakeStorage();
      final newsController = NewsController(getRssFromUrl: (url) => Future.value(feed), myDatabase: fakeStorage);
      final oldItem = feed.items.first;
      final itemId = Uuid().v5(oldItem.title, 'UUID');
      newsController.rssFeedNotifier.value = feed;

      RssItem rssItem = RssItem(title: oldItem.title, guid: itemId);

      expect(fakeStorage.listOfIds.length, 0);
      await newsController.addToHistory(item: rssItem);
      expect(fakeStorage.listOfIds.length, 1);
    });

    test('item isn\'t added to history, already exists', () async {
      FakeStorage fakeStorage = FakeStorage();
      final newsController = NewsController(getRssFromUrl: (url) => Future.value(feed), myDatabase: fakeStorage);
      final oldItem = feed.items.first;
      final itemId = Uuid().v5(oldItem.title, 'UUID');
      newsController.rssFeedNotifier.value = feed;

      RssItem rssItem = RssItem(title: oldItem.title, guid: itemId);
      fakeStorage.historyList.add(rssItem);
      fakeStorage.listOfIds.add(rssItem.guid);

      expect(fakeStorage.historyList.length, 1);
      await newsController.addToHistory(item: rssItem);
      expect(fakeStorage.historyList.length, 1);
    });

    test('deleting leads to empty history list of items', () async {
      FakeStorage fakeStorage = FakeStorage();
      final newsController = NewsController(getRssFromUrl: (url) => Future.value(feed), myDatabase: fakeStorage);
      final oldItem = feed.items.first;
      final itemId = Uuid().v5(oldItem.title, 'UUID');
      newsController.rssFeedNotifier.value = feed;
      RssItem rssItem = RssItem(title: oldItem.title, guid: itemId);

      fakeStorage.historyList.add(rssItem);
      fakeStorage.listOfIds.add(rssItem.guid);

      expect(fakeStorage.historyList.length, 1);
      await newsController.deleteHistory();
      expect(fakeStorage.historyList.length, 0);
    });

    test('deleting leads to empty history list of ids', () async {
      FakeStorage fakeStorage = FakeStorage();
      final newsController = NewsController(getRssFromUrl: (url) => Future.value(feed), myDatabase: fakeStorage);
      final oldItem = feed.items.first;
      final itemId = Uuid().v5(oldItem.title, 'UUID');
      newsController.rssFeedNotifier.value = feed;
      RssItem rssItem = RssItem(title: oldItem.title, guid: itemId);

      fakeStorage.historyList.add(rssItem);
      fakeStorage.listOfIds.add(rssItem.guid);

      expect(fakeStorage.listOfIds.length, 1);
      await newsController.deleteHistory();
      expect(fakeStorage.listOfIds.length, 0);
    });
  });

  group('NewsController', () {});
}

class FakeStorage implements MyStorageConcept {
  List<RssItem> historyList = [];
  List<String> listOfIds = [];
  Stream<List<RssItem>> streamList = Stream.value([]);

  @override
  get addItem => (rssItem) {
        historyList.add(rssItem);
        streamList = Stream.value(historyList);
        print('ADDED NEW ITEM: ${historyList.last.title}');
        listOfIds.add(rssItem.guid);
        print('GUID IS: ${rssItem.guid}');
      };

  @override
  get streamHistory => () => streamList;

  @override
  get deleteHistory => () async {
        historyList.clear();
        streamList = Stream.value(historyList);
        listOfIds = [];
        return null;
      };

  @override
  get retrieveViewedItemIds => () => Future.value(listOfIds);
}

//todo sample test below
//    var expectedFeedValue;
//    this.addToHistory(myItem);
//
//    rssFeedNotifier.addListener(() {
//      expectedFeedValue = rssFeedNotifier.value;
//      print ('notification from rssFeed, ${rssFeedNotifier.value}');
//    });
//
//    expect(expectedFeedValue, myItem);

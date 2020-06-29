import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/main.dart';
import 'package:newsfeed/models/feed_rss_item_model.dart';
import 'package:newsfeed/models/rss_data_source_model.dart';
import 'package:webfeed/webfeed.dart';

import 'rss_data_sample_test.dart';

void main() {
  group('NewsController', () {
    test('retrieving data source list', () {
      FakeStorage fakeStorage = FakeStorage();
      final newsController = NewsController(
        getRssFromUrl: (url) => Future.value(null),
        myDatabase: fakeStorage,
      );
      final rssDataSourcesList = RssDataSourcesList();

      var receivedList = newsController.getDataSource();
      expect(receivedList, rssDataSourcesList.sources);
    });

    test('data source changes', () {
      FakeStorage fakeStorage = FakeStorage();
      final newsController = NewsController(
        getRssFromUrl: (url) => Future.value(null),
        myDatabase: fakeStorage,
      );
      final rssDataSourcesList = RssDataSourcesList();

      newsController.rssDataSourceNotifier.value = null;

      expect(newsController.rssDataSourceNotifier.value, null);
      newsController.changingDataSource(rssDataSourcesList.sources.last.source);
      expect(newsController.rssDataSourceNotifier.value, rssDataSourcesList.sources.last);
    });

    test('checkViewedNews adds feed items to rssFeedNotifier', () async {
      FakeStorage fakeStorage = FakeStorage();
      final newsController = NewsController(
        getRssFromUrl: (url) => Future.value(null),
        myDatabase: fakeStorage,
      );

      var expectedFeedLength;
      newsController.preparedRssFeedNotifier.addListener(() {
        expectedFeedLength = newsController.preparedRssFeedNotifier.value.length;
        print('notification from rssFeed, ${newsController.preparedRssFeedNotifier.value.length}');
      });

      expect(expectedFeedLength, null);
      await newsController.checkViewedNews(fakeRssItems);
      expect(expectedFeedLength, feed.items.length);
    });

    test('isNewsInHistory returns false', () async {
      FakeStorage fakeStorage = FakeStorage();
      final singleItem = [RssItem(title: '123')];
      final newsController = NewsController(
        getRssFromUrl: (url) => Future.value(RssFeed(items: singleItem)),
        myDatabase: fakeStorage,
      );

      var resultBool = await newsController.isNewsInHistory(uuid: singleItem.first.title);
      expect(resultBool, false);
    });

    test('isNewsInHistory returns true', () async {
      FakeStorage fakeStorage = FakeStorage();
      final singleItem = [RssItem(title: '123')];
      final newsController = NewsController(
        getRssFromUrl: (url) => Future.value(RssFeed(items: singleItem)),
        myDatabase: fakeStorage,
      );

//      final itemId = Uuid().v5(feed.items.first.title, 'UUID'); // actually we don't need to implement uuid for testing isInHistory
      fakeStorage.listOfIds.add(singleItem.first.title);

      var resultBool = await newsController.isNewsInHistory(uuid: singleItem.first.title);
      expect(resultBool, true);
    });

    test('item is added to storage when addToHistory is called', () async {
      FakeStorage fakeStorage = FakeStorage();
      final singleItem = [RssItem(title: 'title', guid: '111')];
      final newsController = NewsController(
        getRssFromUrl: (url) => Future.value(RssFeed(items: singleItem)),
        myDatabase: fakeStorage,
      );

      expect(fakeStorage.historyList.length, 0);
      await newsController.addToHistory(item: singleItem.first);
      expect(fakeStorage.historyList.length, 1);
    });

    test('item isn\'t added to history, already exists', () async {
      FakeStorage fakeStorage = FakeStorage();
      final singleItem = [RssItem(title: 'title', guid: '111')];
      final newsController = NewsController(
        getRssFromUrl: (url) => Future.value(RssFeed(items: singleItem)),
        myDatabase: fakeStorage,
      );

      fakeStorage.historyList.add(singleItem.first);
      fakeStorage.listOfIds.add(singleItem.first.guid);

      expect(fakeStorage.historyList.length, 1);
      await newsController.addToHistory(item: singleItem.first);
      expect(fakeStorage.historyList.length, 1);
    });

    test('deleting leads to empty history list of items', () async {
      FakeStorage fakeStorage = FakeStorage();
      final singleItem = [FeedRssItem(item: RssItem(title: 'title', guid: '111'))];
      final newsController = NewsController(
        getRssFromUrl: (url) => Future.value(RssFeed(items: singleItem)),
        myDatabase: fakeStorage,
      );

      fakeStorage.historyList.add(singleItem.first);

      expect(fakeStorage.historyList.length, 1);
      await newsController.deleteHistory();
      expect(fakeStorage.historyList.length, 0);
    });

    test('deleting leads to empty history list of ids', () async {
      FakeStorage fakeStorage = FakeStorage();
      final singleItem = [RssItem(title: 'title', guid: '111')];
      final newsController = NewsController(
        getRssFromUrl: (url) => Future.value(RssFeed(items: singleItem)),
        myDatabase: fakeStorage,
      );

      fakeStorage.listOfIds.add(singleItem.first.guid);

      expect(fakeStorage.listOfIds.length, 1);
      await newsController.deleteHistory();
      expect(fakeStorage.listOfIds.length, 0);
    });
  });

}

class FakeStorage implements MyStorageConcept {
  List<FeedRssItem> historyList = [];
  List<String> listOfIds = [];
  Stream<List<RssItem>> streamList = Stream.value([]);

  @override
  get addItem => (rssItem) async {
        historyList.add(FeedRssItem(item: rssItem, isViewed: true));
        print('ADDED NEW ITEM: ${historyList.last.item.title}');
        listOfIds.add(rssItem.guid);
        streamHistory();
        print('GUID IS: ${rssItem.guid}');
      };

  @override
  get streamHistory => () => Stream.value(historyList);

  @override
  get deleteHistory => () async {
        historyList.clear();
        listOfIds.clear();
        streamHistory();
        return Future.value();
      };

  @override
  get retrieveViewedItemIds => () => Future.value(listOfIds);
}


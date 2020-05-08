import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/main.dart';
import 'package:newsfeed/strings.dart';
import 'package:webfeed/webfeed.dart';

import 'page_view_test.dart';
import 'rss_data_sample_test.dart';

void main() {
  Future<void> givenAppIsPumped(WidgetTester tester, FakeStorage fakeStorage, Completer<RssFeed> completer) async {
    await tester.pumpWidget(
      MyApp(
        getRssFromUrl: (String url) => completer.future,
        myDatabase: fakeStorage,
      ),
    );
  }

  group('data is showed properly in different situations', () {
    testWidgets('Latest and History pages are empty after app is pumped', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeEmptyHistory();
    });

    testWidgets('Pulling down the screen should return news', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      thenShouldSeeLoadingIndicator();
      completer.complete(feed);
      await tester.pumpAndSettle();
      thenShouldFindNews(amount: feed.items.length);
    });

    testWidgets('All news have blank bookmark icons after', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      completer.complete(feed);
      await tester.pumpAndSettle();
      thenShouldFindNews(amount: feed.items.length);
      expect(find.byIcon(Icons.bookmark_border), findsNWidgets(feed.items.length));
    });

    testWidgets('News has title and description', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      completer.complete(feed);
      await tester.pumpAndSettle();
      expect(find.text(feed.items.first.title), findsOneWidget);
      expect(find.text(feed.items.first.description), findsOneWidget);
    });

    testWidgets('news page opens after selecting in news list', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      completer.complete(feed);
      await tester.pumpAndSettle();
      await whenUserTapsFirstItemInNewsList(tester);
      thenShouldBeInSelectedNews();
    });

    testWidgets('tapping on backButton in selected news returning to news list', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      completer.complete(feed);
      await tester.pumpAndSettle();
      await whenUserTapsFirstItemInNewsList(tester);
      thenShouldBeInSelectedNews();
      await whenUserGoesBack(tester);
      thenShouldFindNews(amount: fakeRssItems.length);
    });

    testWidgets('viewed news has filled bookmark icon', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      completer.complete(feed);
      await tester.pumpAndSettle();
      await whenUserTapsFirstItemInNewsList(tester);
      thenShouldBeInSelectedNews();
      await whenUserGoesBack(tester);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('viewed news should be in history page', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      completer.complete(feed);
      await tester.pumpAndSettle();
      await whenUserTapsFirstItemInNewsList(tester);
      await whenUserGoesBack(tester);
      await whenSwipeToRightToChangePage(tester);
      thenShouldSeeNewsInHistory(feed);
      expect(find.text(EMPTY_HISTORY), findsNothing);
    });

    //TODO not working yet. streeeeaaaammmm
    testWidgets('history page: taps to delete icon should delete history', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      await whenUserPullsToRefresh(tester);
      completer.complete(feed);
      await tester.pumpAndSettle();
      await whenUserTapsFirstItemInNewsList(tester);
      await whenUserGoesBack(tester);
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeInHistoryPage(); //todo pointless 130-134
      thenShouldSeeNewsInHistory(feed);
      expect(find.text(EMPTY_HISTORY), findsNothing);
      await whenUserTapsToDeleteIcon(tester);
      thenShouldBeEmptyHistory();
    });

    testWidgets('latest page: taps to delete icon should delete history', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      completer.complete(feed);
      await tester.pumpAndSettle();
      await whenUserTapsFirstItemInNewsList(tester);
      await whenUserGoesBack(tester);
      await whenSwipeToRightToChangePage(tester);
      thenShouldSeeNewsInHistory(feed);
      await whenSwipeToLeftToChangePage(tester);
      thenShouldBeInLatestPage();
      await whenUserTapsToDeleteIcon(tester);
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeEmptyHistory();
    });
  });
}

void thenShouldSeeLoadingIndicator() {
  expect(find.byType(RefreshProgressIndicator), findsOneWidget);
}

void thenShouldBeEmptyLatestPage() {
  expect(find.byKey(ValueKey('latestNewsPage')), findsOneWidget);
  expect(find.byKey(ValueKey('historyNewsPage')), findsNothing);
  expect(find.text(PULL_DOWN_TO_UPDATE), findsOneWidget);
}

void thenShouldFindNews({int amount}) {
  expect(find.byType(ListTile), findsNWidgets(amount));
}

void thenShouldBeInSelectedNews() {
  expect(find.text(CONTINUE_READING), findsOneWidget);
  expect(find.byIcon(Icons.open_in_new), findsOneWidget);
  expect(find.byType(BackButtonIcon), findsOneWidget);
}

void thenShouldSeeNewsInHistory(RssFeed feed) {
  //todo rewrite
  expect(find.byType(ListTile), findsOneWidget);
  expect(find.text(feed.items.first.title), findsOneWidget);
}

void thenShouldBeEmptyHistory() {
  expect(find.text(EMPTY_HISTORY), findsOneWidget);
  expect(find.byType(ListTile), findsNothing);
}

Future whenUserPullsToRefresh(WidgetTester tester) async {
  await tester.drag(find.byType(RefreshIndicator), Offset(100.0, 500.0));
  await tester.pump();
}

Future whenUserTapsFirstItemInNewsList(WidgetTester tester) async {
  await tester.tap(find.text(feed.items.first.title));
  await tester.pumpAndSettle();
}

Future whenUserGoesBack(WidgetTester tester) async {
  await tester.tap(find.byType(BackButtonIcon));
  await tester.pumpAndSettle();
}

Future whenUserTapsToDeleteIcon(WidgetTester tester) async {
  await tester.tap(find.byKey(ValueKey('deleteIcon'))); //todo byKey
  await tester.pumpAndSettle();
}

class FakeStorage implements MyStorageConcept {
  List<RssItem> historyList = [];
  List<String> listOfIds = [];

//  Stream<List<RssItem>> streamList = Stream.value([]);
  StreamController streamController = StreamController();

  //todo StreamController

  void dispose() {
    streamController.close();
  }

  @override
  get addItem =>
          (rssItem) async {
        historyList.add(rssItem);
        print('ADDED NEW ITEM: ${historyList.last.title}');
        listOfIds.add(rssItem.guid);
        Future.value(streamHistory());
        print('GUID IS: ${rssItem.guid}');
      };

  @override
  get streamHistory => () => Stream.value(historyList);

  @override
  get deleteHistory =>
          () async {
        historyList.clear();
        listOfIds.clear();
        Future.value(streamHistory());
        return Future.value();
      };

  @override
  get retrieveViewedItemIds => () => Future.value(listOfIds);
}

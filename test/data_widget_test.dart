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
        myStorage: fakeStorage,
      ),
    );
  }

  group('fetching data', () {
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
      await whenUserTapsToNews(tester);
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
      await whenUserTapsToNews(tester);
      thenShouldBeInSelectedNews();
      await whenUserTapsToBackButton(tester);
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
      await whenUserTapsToNews(tester);
      thenShouldBeInSelectedNews();
      await whenUserTapsToBackButton(tester);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('viewed news should be in history page', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      fakeStorage.historyList = [];
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      completer.complete(feed);
      await tester.pumpAndSettle();
      await whenUserTapsToNews(tester);
      await whenUserTapsToBackButton(tester);
      await whenSwipeToRightToChangePage(tester);
      thenShouldNewsIsFoundInHistory();
      expect(find.text(EMPTY_HISTORY), findsNothing);
    });

    testWidgets('history page: taps to delete icon should delete history', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      fakeStorage.historyList = [];
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      completer.complete(feed);
      await tester.pumpAndSettle();
      await whenUserTapsToNews(tester);
      await whenUserTapsToBackButton(tester);
      await whenSwipeToRightToChangePage(tester);
      thenShouldNewsIsFoundInHistory();
      expect(find.text(EMPTY_HISTORY), findsNothing);
      await whenUserTapsToDeleteIcon(tester);
      thenShouldBeEmptyHistory();
    });

    testWidgets('latest page: taps to delete icon should delete history', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      fakeStorage.historyList = [];
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      completer.complete(feed);
      await tester.pumpAndSettle();
      await whenUserTapsToNews(tester);
      await whenUserTapsToBackButton(tester);
      await whenSwipeToRightToChangePage(tester);
      thenShouldNewsIsFoundInHistory();
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

void thenShouldNewsIsFoundInHistory() {
  expect(find.byType(ListTile), findsOneWidget);
}

void thenShouldBeEmptyHistory() {
  expect(find.byType(ListTile), findsNothing);
  expect(find.text(EMPTY_HISTORY), findsOneWidget);
}

Future whenUserPullsToRefresh(WidgetTester tester) async {
  await tester.drag(find.byType(RefreshIndicator), Offset(100.0, 500.0));
  await tester.pump();
}

Future whenUserTapsToNews(WidgetTester tester) async {
  await tester.tap(find.text(feed.items.first.title));
  await tester.pumpAndSettle();
}

Future whenUserTapsToBackButton(WidgetTester tester) async {
  await tester.tap(find.byType(BackButtonIcon));
  await tester.pumpAndSettle();
}

Future whenUserTapsToDeleteIcon(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.delete));
  await tester.pumpAndSettle();
}

class FakeStorage implements MyStorageConcept {
  List<RssItem> historyList = [];

  @override
  get addItem =>
          (rssItem) {
        historyList.add(rssItem);
        print('ADDED NEW ITEM: ${historyList.last.title}');
      };

  @override
  get isItemInHistory =>
          (link) {
        bool myBool = false;
        for (var i = 0; i < historyList.length; i++) {
          if (historyList[i].link == link) {
            return myBool = true;
          }
        }
        return myBool;
      };

  @override
  get getAll => () => historyList;

  @override
  get deleteHistory => () => historyList = [];
}

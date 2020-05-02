import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/main.dart';
import 'package:newsfeed/strings.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';

import 'page_view_test.dart';
import 'rss_data_sample_test.dart';

RssFeed myList = RssFeed(items: []);
List<RssItem> historyList = [];

FakeStorage fakeStorage = FakeStorage();

void main() {
  Future<void> givenAppIsPumped(WidgetTester tester, FakeStorage fakeStorage) async {
    await tester.pumpWidget(Provider<RssDataSourceController>(
      create: (_) => RssDataSourceController(),
      child: MyApp(
        getRssFromUrl: (String url) => Future.value(myList),
        myStorage: fakeStorage,
      ),
    ));
  }

  group('fetching data', () {
    testWidgets('Pulling down the screen should return news', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      historyList = [];
      myList.items.addAll(fakeRssItems);
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      thenShouldFindNews(amount: fakeRssItems.length);
    });

    testWidgets('All news have blank bookmark icons after', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      historyList = [];
      myList.items.clear();
      myList.items.addAll(fakeRssItems);
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      thenShouldFindNews(amount: fakeRssItems.length);
      expect(find.byIcon(Icons.bookmark_border), findsNWidgets(fakeRssItems.length));
    });

    testWidgets('News has title and description', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      historyList = [];
      myList.items.clear();
      myList.items.addAll(fakeRssItems);
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      expect(find.text(myList.items.first.title), findsOneWidget);
      expect(find.text(myList.items.first.description), findsOneWidget);
    });

    testWidgets('news page opens after selecting in news list', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      historyList = [];
      myList.items.clear();
      myList.items.addAll(fakeRssItems);
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      await whenUserTapsToNews(tester);
      thenShouldBeInSelectedNews();
    });

    testWidgets('tapping on bacButton returning to news list', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      historyList = [];
      myList.items.clear();
      myList.items.addAll(fakeRssItems);
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      await whenUserTapsToNews(tester);
      thenShouldBeInSelectedNews();
      await whenUserTapsToBackButton(tester);
      thenShouldFindNews(amount: fakeRssItems.length);
    });

    testWidgets('viewed news has filled bookmark icon', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      historyList = [];
      myList.items.clear();
      myList.items.addAll(fakeRssItems);
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      await whenUserTapsToNews(tester);
      thenShouldBeInSelectedNews();
      await whenUserTapsToBackButton(tester);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('viewed news should be in history page', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      historyList = [];
      myList.items.clear();
      myList.items.addAll(fakeRssItems);
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeEmptyLatestPage();
      await whenUserPullsToRefresh(tester);
      await whenUserTapsToNews(tester);
      await whenUserTapsToBackButton(tester);
      await whenSwipeToRightToChangePage(tester);
      thenShouldNewsIsFoundInHistory();
      expect(find.text(EMPTY_HISTORY), findsNothing);
    });

  });
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

Future whenUserPullsToRefresh(WidgetTester tester) async {
  await tester.drag(find.byType(RefreshIndicator), Offset(100.0, 500.0));
  await tester.pumpAndSettle();
}

Future whenUserTapsToNews(WidgetTester tester) async {
  await tester.tap(find.text(myList.items.first.title));
  await tester.pumpAndSettle();
}

Future whenUserTapsToBackButton(WidgetTester tester) async {
  await tester.tap(find.byType(BackButtonIcon));
  await tester.pumpAndSettle();
}


class FakeStorage implements MyStorageConcept {
  @override
  get addItemToHistory =>
          (rssItem) {
        historyList.add(rssItem);
        print('ADDED NEW ITEM: ${historyList.last.title}');
      };

  @override
  get checkNewsInHistoryByLink =>
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
  get getAllStorageItems => () => historyList;
}

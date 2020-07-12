import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/main.dart';
import 'package:webfeed/webfeed.dart';

import 'data_widget_test.dart';
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

  group('search use cases', () {
    testWidgets('Latest and History pages are empty after app is pumped', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeEmptyHistory();
    });

    testWidgets('Should find empty search page', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      thenShouldBeEmptyLatestPage();
      await whenSwipeToRightToChangePage(tester);
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeEmptySearchList();
    });

    testWidgets('Search field shows user query', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      await whenSwipeToRightToChangePage(tester);
      await whenSwipeToRightToChangePage(tester);
      final testQuery = 'Hello world';
      await whenUserWriteSearchQuery(tester, testQuery);
      thenShouldQueryBeInTextField(testQuery);
    });

    testWidgets('No query should find load items', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      fakeStorage.historyList.addAll(feed.items);
      await whenSwipeToRightToChangePage(tester);
      await whenSwipeToRightToChangePage(tester);
      final testQuery = '';
      await whenUserWriteSearchQuery(tester, testQuery);
      await whenUserPressSearchButton(tester);
      thenItemsShouldBeFound();
    });

    testWidgets('Searching specific query wont find any results', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      fakeStorage.historyList.addAll(feed.items);
      await whenSwipeToRightToChangePage(tester);
      await whenSwipeToRightToChangePage(tester);
      final testQuery = 'specific query';
      await whenUserWriteSearchQuery(tester, testQuery);
      await whenUserPressSearchButton(tester);
      thenItemsShouldNotBeFound();
    });

    testWidgets('Items should be found by searching', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      Completer<RssFeed> completer = Completer();
      await givenAppIsPumped(tester, fakeStorage, completer);
      fakeStorage.historyList.addAll(feed.items);
      await whenSwipeToRightToChangePage(tester);
      await whenSwipeToRightToChangePage(tester);
      final testQuery = feed.items.first.title;
      await whenUserWriteSearchQuery(tester, testQuery);
      await whenUserPressSearchButton(tester);
      thenItemsShouldBeFound();
    });
  });
}

void thenShouldBeEmptySearchList() {
  expect(find.byKey(PageStorageKey('initialEmptySearchList')), findsOneWidget);
}

void thenShouldQueryBeInTextField(String query) {
  expect(find.text(query), findsOneWidget);
}

void thenItemsShouldNotBeFound() {
  expect(find.byKey(ValueKey('itemsNotFound')), findsOneWidget);
}

void thenItemsShouldBeFound() {
  expect(find.byKey(PageStorageKey('resultsItems')), findsOneWidget);
}

Future whenUserWriteSearchQuery(WidgetTester tester, String query) async {
  await tester.enterText(find.byKey(PageStorageKey('searchField')), query);
  await tester.pumpAndSettle();
}

Future whenUserPressSearchButton(WidgetTester tester) async {
  await tester.tap(find.byKey(ValueKey('searchButton')));
  await tester.pump();
}

class FakeStorage implements MyStorageConcept {
  List<RssItem> historyList = [];
  List<String> listOfIds = [];

  @override
  get addItem => (rssItem) async {
        historyList.add(rssItem);
        print('ADDED NEW ITEM: ${historyList.last.title}');
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

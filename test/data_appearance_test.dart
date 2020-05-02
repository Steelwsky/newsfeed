import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/main.dart';
import 'package:newsfeed/strings.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';

import 'rss_data_sample_test.dart';

RssFeed myList = RssFeed(items: []);

void main() {
  Future<void> givenAppIsPumped(WidgetTester tester) async {
    await tester.pumpWidget(Provider<RssDataSourceController>(
      create: (_) => RssDataSourceController(),
      child: MyApp(getRssFromUrl: (String url) => Future.value(myList)),
    ));
  } //MyApp(fakeNetWorkData)

  group('fetching data', () {
    testWidgets('Pulling down the screen should return news', (WidgetTester tester) async {
      await givenAppIsPumped(tester);
      thenShouldBeEmptyLatestPage();
      myList.items.addAll(fakeRssItems);
      await whenUserPullsToRefresh(tester);
      thenShouldFindNews(amount: fakeRssItems.length);
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

Future whenUserPullsToRefresh(WidgetTester tester) async {
  await tester.drag(find.byType(RefreshIndicator), Offset(100.0, 500.0));
  await tester.pumpAndSettle();
}

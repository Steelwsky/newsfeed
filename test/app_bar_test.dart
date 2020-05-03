import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/main.dart';
import 'package:webfeed/webfeed.dart';

import 'data_widget_test.dart';
import 'page_view_test.dart';

RssFeed myList = RssFeed(items: []);

FakeStorage fakeStorage = FakeStorage();

void main() {
  Future<void> givenAppIsPumped(WidgetTester tester, FakeStorage fakeStorage) async {
    await tester.pumpWidget(
      MyApp(
        getRssFromUrl: (String url) => Future.value(myList),
        myStorage: fakeStorage,
      ),
    );
  }

  group('my PageView correctly works', () {
    testWidgets('Should have LATEST in app bar after app is pumped', (WidgetTester tester) async {
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeLatestInAppBar();
    });

    testWidgets('Should have HISTORY in app bar after swiping page', (WidgetTester tester) async {
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeLatestInAppBar();
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeHistoryInAppBar();
    });
  });
}

void thenShouldBeLatestInAppBar() {
  expect(find.byKey(ValueKey('LatestAppBar')), findsOneWidget);
  expect(find.byKey(ValueKey('HistoryAppBar')), findsNothing);
}

void thenShouldBeHistoryInAppBar() {
  expect(find.byKey(ValueKey('HistoryAppBar')), findsOneWidget);
  expect(find.byKey(ValueKey('LatestAppBar')), findsNothing);
}

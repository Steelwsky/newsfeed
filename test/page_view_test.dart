import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/history_news_page.dart';
import 'package:newsfeed/latest_news_page.dart';
import 'package:newsfeed/main.dart';
import 'package:provider/provider.dart';

import 'data_appearance_test.dart';


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

  group('Swiping pages correctly works', () {
    testWidgets('Should see latest page after app is pumped', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeLatestPage();
    });

    testWidgets('Should see history page after swipe', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeLatestPage();
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeEmptyHistoryPage();
    });

    testWidgets('Swiping back from history page should return to latest page', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeLatestPage();
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeEmptyHistoryPage();
      await whenSwipeToLeftToChangePage(tester);
      thenShouldBeLatestPage();
    });
  });

  group('Clicking pages via nav bar correctly works', () {
    testWidgets('Should see history page after clicking tab in nav bar', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeLatestPage();
      await whenClickToChangePage(tester, Icons.history);
      thenShouldBeEmptyHistoryPage();
    });

    testWidgets('Should see latest page after clicking tab in nav bar', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeLatestPage();
      await whenClickToChangePage(tester, Icons.history);
      thenShouldBeEmptyHistoryPage();
      await whenClickToChangePage(tester, Icons.home);
      thenShouldBeLatestPage();
    });
  });
}

Future whenSwipeToRightToChangePage(WidgetTester tester) async {
  await tester.fling(find.byType(LatestNewsPage), Offset(-300.0, 0.0), 1000);
  await tester.pumpAndSettle();
}

Future whenSwipeToLeftToChangePage(WidgetTester tester) async {
  await tester.fling(find.byType(HistoryNewsPage), Offset(300.0, 0.0), 1000);
  await tester.pumpAndSettle();
}

Future whenClickToChangePage(WidgetTester tester, IconData icon) async {
  await tester.tap(find.byIcon(icon));
  await tester.pumpAndSettle();
}

void thenShouldBeLatestPage() {
  expect(find.byKey(ValueKey('latestNewsPage')), findsOneWidget);
  expect(find.byKey(ValueKey('emptyHistory')), findsNothing);
}

void thenShouldBeEmptyHistoryPage() {
  expect(find.byKey(ValueKey('emptyHistory')), findsOneWidget);
  expect(find.byKey(ValueKey('latestNewsPage')), findsNothing);
}

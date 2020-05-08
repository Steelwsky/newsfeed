import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/history_news_page.dart';
import 'package:newsfeed/latest_news_page.dart';
import 'package:newsfeed/main.dart';

import 'data_widget_test.dart';
import 'rss_data_sample_test.dart';


void main() {
  Future<void> givenAppIsPumped(WidgetTester tester, FakeStorage fakeStorage) async {
    await tester.pumpWidget(MyApp(
      getRssFromUrl: (String url) => Future.value(feed),
      myDatabase: fakeStorage,
      ),
    );
  }

  group('Swiping pages correctly works', () {
    testWidgets('Should see latest page after app is pumped', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeInLatestPage();
    });

    testWidgets('Should see history page after swipe', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeInLatestPage();
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeInHistoryPage();
    });

    testWidgets('Swiping back from history page should return to latest page', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeInLatestPage();
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeInHistoryPage();
      await whenSwipeToLeftToChangePage(tester);
      thenShouldBeInLatestPage();
    });
  });

  group('Clicking pages via nav bar correctly works', () {
    testWidgets('Should see history page after clicking tab in nav bar', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeInLatestPage();
      await whenClickToChangePage(tester, Icons.history);
      thenShouldBeInHistoryPage();
    });

    testWidgets('Should see latest page after clicking tab in nav bar', (WidgetTester tester) async {
      FakeStorage fakeStorage = FakeStorage();
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeInLatestPage();
      await whenClickToChangePage(tester, Icons.history);
      thenShouldBeInHistoryPage();
      await whenClickToChangePage(tester, Icons.home);
      thenShouldBeInLatestPage();
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

void thenShouldBeInLatestPage() {
  expect(find.byKey(ValueKey('latestNewsPage')), findsOneWidget);
  expect(find.byKey(ValueKey('historyPage')), findsNothing);
}

void thenShouldBeInHistoryPage() {
  expect(find.byKey(ValueKey('historyPage')), findsOneWidget);
  expect(find.byKey(ValueKey('latestNewsPage')), findsNothing);
}

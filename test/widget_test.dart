import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/history_news_page.dart';
import 'package:newsfeed/latest_news_page.dart';

import 'package:newsfeed/main.dart';

void main() {
  Future<void> givenAppIsPumped(WidgetTester tester) async {
    await tester.pumpWidget(MyApp()); //MyApp(fakeNetWorkData)
  }

  group('pageView correctly works', () {

    testWidgets('Should see latest page after app is pumped', (WidgetTester tester) async {
     await givenAppIsPumped(tester);
     thenShouldBeLatestPage();
    });

    testWidgets('Should see history page after swipe', (WidgetTester tester) async {
      await givenAppIsPumped(tester);
      thenShouldBeLatestPage();
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeHistoryPage();
    });

    testWidgets('Swiping back from history page should return to latest page', (WidgetTester tester) async {
      await givenAppIsPumped(tester);
      thenShouldBeLatestPage();
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeHistoryPage();
      await whenSwipeToLeftToChangePage(tester);
      thenShouldBeLatestPage();
    });
  });
}

void thenShouldBeLatestPage() {
  expect(find.byKey(ValueKey('latestNewsPage')), findsOneWidget);
  expect(find.byKey(ValueKey('historyNewsPage')), findsNothing);
}

void thenShouldBeHistoryPage() {
  expect(find.byKey(ValueKey('historyNewsPage')), findsOneWidget);
  expect(find.byKey(ValueKey('latestNewsPage')), findsNothing);
}

Future whenSwipeToRightToChangePage(WidgetTester tester) async {
  await tester.fling(find.byType(LatestNewsPage), Offset(-300.0, 0.0), 1000);
  await tester.pumpAndSettle();
}

Future whenSwipeToLeftToChangePage(WidgetTester tester) async {
  await tester.fling(find.byType(HistoryNewsPage), Offset(300.0, 0.0), 1000);
  await tester.pumpAndSettle();
}

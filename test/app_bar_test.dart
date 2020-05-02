import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/latest_news_page.dart';

import 'package:newsfeed/main.dart';
import 'package:newsfeed/strings.dart';

void main() {
  Future<void> givenAppIsPumped(WidgetTester tester) async {
    await tester.pumpWidget(MyApp()); //MyApp(fakeNetWorkData)
  }

  group('pageView correctly works', () {
    testWidgets('Should have LATEST in app bar after app is pumped', (WidgetTester tester) async {
      await givenAppIsPumped(tester);
      thenShouldBeLatestInAppBar();
    });

    testWidgets('Should have HISTORY in app bar after swiping page', (WidgetTester tester) async {
      await givenAppIsPumped(tester);
      thenShouldBeLatestInAppBar();
      await whenSwipeToRightToChangePage(tester);
      thenShouldBeHistoryInAppBar();
    });
  });
}

void thenShouldBeLatestInAppBar() {
  expect(find.text(LATEST), findsOneWidget);
  expect(find.text(HISTORY), findsNothing);
}

void thenShouldBeHistoryInAppBar() {
  expect(find.text(HISTORY), findsOneWidget);
  expect(find.text(LATEST), findsNothing);
}

Future whenSwipeToRightToChangePage(WidgetTester tester) async {
  await tester.fling(find.byType(LatestNewsPage), Offset(-300.0, 0.0), 1000);
  await tester.pumpAndSettle();
}

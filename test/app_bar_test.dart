import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/main.dart';
import 'package:provider/provider.dart';

import 'page_view_test.dart';

void main() {
  Future<void> givenAppIsPumped(WidgetTester tester) async {
    await tester.pumpWidget(Provider<RssDataSourceController>(
      create: (_) => RssDataSourceController(),
      child: MyApp(),
    ));
  }

  group('my PageView correctly works', () {
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
  expect(find.byKey(ValueKey('LatestAppBar')), findsOneWidget);
  expect(find.byKey(ValueKey('HistoryAppBar')), findsNothing);
}

void thenShouldBeHistoryInAppBar() {
  expect(find.byKey(ValueKey('HistoryAppBar')), findsOneWidget);
  expect(find.byKey(ValueKey('LatestAppBar')), findsNothing);
}



import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsfeed/app_bar.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/main.dart';
import 'package:newsfeed/strings.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';

import 'data_appearance_test.dart';

RssFeed myList = RssFeed(items: []);

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

  group('Drawer works properly', () {
    testWidgets('Should see drawer icon to open after app is pumped', (WidgetTester tester) async {
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldBeDrawerIconInAppBar();
    });

    testWidgets('expect NO drawer opened when app is pumped', (WidgetTester tester) async {
      await givenAppIsPumped(tester, fakeStorage);
      thenShouldHaveClosedDrawer();
    });

    testWidgets('expect drawer opens via swipe from left corner to center', (WidgetTester tester) async {
      await givenAppIsPumped(tester, fakeStorage);
      await whenUserSwipesToCallDrawer(tester);
      thenShouldHaveOpenedDrawer();
    });

    testWidgets('expect drawer opens via menu button', (WidgetTester tester) async {
      await givenAppIsPumped(tester, fakeStorage);
      await whenUserSwipesToCallDrawer(tester);
      thenShouldHaveOpenedDrawer();
    });

    testWidgets('expect two items in opened drawer', (WidgetTester tester) async {
      await givenAppIsPumped(tester, fakeStorage);
      await whenUserSwipesToCallDrawer(tester);
      thenShouldHaveOpenedDrawer();
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets('drawer closes after a tap on one of the items', (WidgetTester tester) async {
      await givenAppIsPumped(tester, fakeStorage);
      await whenUserSwipesToCallDrawer(tester);
      expect(find.byKey(ValueKey('NY Times')), findsOneWidget);
      await whenUserSelectsSourceInDrawer(tester);
      await tester.pumpAndSettle();
      thenShouldHaveClosedDrawer();
    });

    testWidgets('changing news source should change title in AppBar', (WidgetTester tester) async {
      await givenAppIsPumped(tester, fakeStorage);
      expect(find.text('Latest - CNBC'), findsOneWidget);
      expect(find.text('Latest - NY Times'), findsNothing);
      await whenUserSwipesToCallDrawer(tester);
      await whenUserSelectsSourceInDrawer(tester);
      await tester.pumpAndSettle();
      thenShouldHaveClosedDrawer();
      expect(find.text('Latest - CNBC'), findsNothing);
      expect(find.text('Latest - NY Times'), findsOneWidget);
    });

    testWidgets('changing news source should change title in AppBar', (WidgetTester tester) async {
      await givenAppIsPumped(tester, fakeStorage);
      expect(find.text('Latest - CNBC'), findsOneWidget);
      expect(find.text('Latest - NY Times'), findsNothing);
      await whenUserSwipesToCallDrawer(tester);
      await whenUserSelectsSourceInDrawer(tester);
      await tester.pumpAndSettle();
      thenShouldHaveClosedDrawer();
      expect(find.text('Latest - CNBC'), findsNothing);
      expect(find.text('Latest - NY Times'), findsOneWidget);
    });

    testWidgets('expect drawer has still 1 selected and 1 unseleted items after one of them was taped',
        (WidgetTester tester) async {
          await givenAppIsPumped(tester, fakeStorage);
      await whenUserSwipesToCallDrawer(tester);
      expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      await whenUserSelectsSourceInDrawer(tester);
      await tester.pumpAndSettle();
      thenShouldHaveClosedDrawer();
      await whenUserSwipesToCallDrawer(tester);
      expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    });
  });
}

Future whenUserSwipesToCallDrawer(WidgetTester tester) async {
  await tester.dragFrom(tester.getTopLeft(find.byType(MyAppBar)), Offset(300, 0));
  await tester.pumpAndSettle();
}

Future whenUserTapsToMenuIconToCallDrawer(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
}

Future whenUserSelectsSourceInDrawer(WidgetTester tester) async {
  await tester.tap(find.byKey(ValueKey('NY Times')));
  await tester.pumpAndSettle();
}

void thenShouldBeDrawerIconInAppBar() {
  expect(find.byIcon(Icons.menu), findsOneWidget);
}

void thenShouldHaveOpenedDrawer() {
  expect(find.text(SELECT_NEWS_SOURCE), findsOneWidget);
  expect(find.byKey(ValueKey('CNBC')), findsOneWidget);
  expect(find.byKey(ValueKey('NY Times')), findsOneWidget);
}

void thenShouldHaveClosedDrawer() {
  expect(find.text(SELECT_NEWS_SOURCE), findsNothing);
}

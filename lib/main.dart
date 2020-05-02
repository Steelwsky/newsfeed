import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/my_repository.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';

import 'home_page.dart';

final MyRepository myRepository = MyRepository();

typedef GetRssFromUrl = Future<RssFeed> Function(String url);

typedef AddItemToHistory = void Function(RssItem item);
typedef CheckNewsInHistoryByLink = bool Function(String link);
typedef GetAllStorageItems = List<RssItem> Function();

class NetworkResponseToRssParser {
  RssFeed mapToRss(http.Response response) {
    final xmlStr = response.body;
    final parsedNews = RssFeed.parse(xmlStr);
    return parsedNews;
  }
}

abstract class MyStorageConcept {
  MyStorageConcept({this.addItemToHistory, this.checkNewsInHistoryByLink, this.getAllStorageItems});

  final AddItemToHistory addItemToHistory;
  final CheckNewsInHistoryByLink checkNewsInHistoryByLink;
  final GetAllStorageItems getAllStorageItems;
}

class MyStorage implements MyStorageConcept {
  @override
  AddItemToHistory get addItemToHistory => myRepository.addToHistory;

  @override
  CheckNewsInHistoryByLink get checkNewsInHistoryByLink => myRepository.isViewedItemByLink;

  @override
  GetAllStorageItems get getAllStorageItems => myRepository.getCurrentList;
}

void main() {
  final client = http.Client();
  final rssParser = NetworkResponseToRssParser();
  final MyStorageConcept myStorage = MyStorage();

  runApp(
    Provider<RssDataSourceController>(
      create: (_) => RssDataSourceController(),
      child: MyApp(
          getRssFromUrl: (url) =>
              client.get(url).then((data) {
                return rssParser.mapToRss(data);
              }),
          myStorage: myStorage),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({this.getRssFromUrl, this.myStorage});

  final GetRssFromUrl getRssFromUrl;
  final MyStorageConcept myStorage;

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    final rssDataSourceController = Provider.of<RssDataSourceController>(context);
    return MultiProvider(
        providers: [
          Provider<MyPageController>(create: (_) => MyPageController(pageController: pageController)),
          Provider<NewsController>(
              create: (_) =>
                  NewsController(
                      getRssFromUrl: getRssFromUrl,
                      rssDataSourceController: rssDataSourceController,
                      myStorage: myStorage)),
        ],
        child: MaterialApp(
            title: 'News Feed',
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
            ),
            home: MyHomePage(myStorage: myStorage)));
  }
}

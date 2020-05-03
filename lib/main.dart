import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/my_repository.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';

import 'home_page.dart';


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
  MyStorageConcept({this.addItem, this.isItemInHistory, this.getAll});

  final AddItemToHistory addItem;
  final CheckNewsInHistoryByLink isItemInHistory;
  final GetAllStorageItems getAll;
}

class MyStorage implements MyStorageConcept {
  MyRepository myRepository = MyRepository();

  @override
  AddItemToHistory get addItem => myRepository.addToHistory;

  @override
  CheckNewsInHistoryByLink get isItemInHistory => myRepository.isViewedItemByLink;

  @override
  GetAllStorageItems get getAll => myRepository.getCurrentList;
}

void main() {
  final client = http.Client();
  final rssParser = NetworkResponseToRssParser();
  final MyStorageConcept myStorage = MyStorage();

  runApp(MyApp(
    getRssFromUrl: (url) => client.get(url).then(rssParser.mapToRss),
    myStorage: myStorage,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({this.getRssFromUrl, this.myStorage});

  final GetRssFromUrl getRssFromUrl;
  final MyStorageConcept myStorage;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<MyPageController>(create: (_) => MyPageController(pageController: pageController)),
          Provider<NewsController>(
              create: (_) =>
                  NewsController(
                      getRssFromUrl: widget.getRssFromUrl,
                      myStorage: widget.myStorage)),
        ],
        child: MaterialApp(
            title: 'News Feed',
            theme: ThemeData(primarySwatch: Colors.deepPurple),
            home: MyHomePage(myStorage: widget.myStorage)));
  }
}

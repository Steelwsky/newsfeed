import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';

import 'firestore_service.dart';
import 'home_page.dart';

typedef GetRssFromUrl = Future<RssFeed> Function(String url);
typedef AddItemToHistory = void Function(RssItem item);
typedef GetStreamHistory = Stream<List<RssItem>> Function();
typedef DeleteHistory = Future<void> Function();
typedef RetrieveViewedItemIds = Future<List<String>> Function();

class NetworkResponseToRssParser {
  RssFeed mapToRss(http.Response response) {
    final xmlStr = response.body;
    final parsedNews = RssFeed.parse(xmlStr);
    return parsedNews;
  }
}

abstract class MyStorageConcept {
  MyStorageConcept({this.addItem, this.streamHistory, this.deleteHistory, this.retrieveViewedItemIds});

  final AddItemToHistory addItem;
  final GetStreamHistory streamHistory;
  final DeleteHistory deleteHistory;
  final RetrieveViewedItemIds retrieveViewedItemIds;
}

class MyDatabase implements MyStorageConcept {

  FirestoreDatabase firestoreDatabase = FirestoreDatabase();

  @override
  AddItemToHistory get addItem => firestoreDatabase.addToHistory;

  @override
  GetStreamHistory get streamHistory => firestoreDatabase.getHistory; //rename getAll

  @override
  DeleteHistory get deleteHistory => firestoreDatabase.deleteHistory;

  @override
  RetrieveViewedItemIds get retrieveViewedItemIds => firestoreDatabase.retrieveViewedItemIds;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final client = http.Client();
  final rssParser = NetworkResponseToRssParser();
  final MyStorageConcept myDatabase = MyDatabase();

  runApp(MyApp(
    getRssFromUrl: (url) => client.get(url).then(rssParser.mapToRss),
    myDatabase: myDatabase,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({this.getRssFromUrl, this.myDatabase});

  final GetRssFromUrl getRssFromUrl;
  final MyStorageConcept myDatabase;

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
              create: (_) => NewsController(getRssFromUrl: widget.getRssFromUrl, myDatabase: widget.myDatabase)),
        ],
        child: MaterialApp(
          title: 'News Feed',
          theme: ThemeData(primarySwatch: Colors.deepPurple),
          home: MyHomePage(),
        ));
  }
}

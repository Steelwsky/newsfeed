import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';

import 'home_page.dart';

typedef GetRssFromUrl = Future<RssFeed> Function(String url);

class NetworkResponseToRssParser {
  RssFeed mapToRss(http.Response response) {
    final xmlStr = response.body;
    final parsedNews = RssFeed.parse(xmlStr);
    return parsedNews;
  }
}

void main() {
  final client = http.Client();
  final rssParser = NetworkResponseToRssParser();
  runApp(
    Provider<RssDataSourceController>(
      create: (_) => RssDataSourceController(),
      child: MyApp(
          getRssFromUrl: (url) =>
              client.get(url).then((data) {
                return rssParser.mapToRss(data);
              })),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({this.getRssFromUrl});

  final GetRssFromUrl getRssFromUrl;

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    final rssDataSourceController = Provider.of<RssDataSourceController>(context);
    return MultiProvider(
        providers: [
          Provider<MyPageController>(create: (_) => MyPageController(pageController: pageController)),
          Provider<NewsController>(
              create: (_) =>
                  NewsController(getRssFromUrl: getRssFromUrl, rssDataSourceController: rssDataSourceController)),
        ],
        child: MaterialApp(
            title: 'News Feed',
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
            ),
            home: MyHomePage()));
  }
}

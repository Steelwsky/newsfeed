import 'package:webfeed/webfeed.dart';

List<RssItem> fakeRssItems = [
  RssItem(title: 'ItemTitle 1', description: 'Description 1', link: 'link1', guid: 'guid1'),
  RssItem(title: 'ItemTitle 2', description: 'Description 2', link: 'link2', guid: 'guid2'),
  RssItem(title: 'ItemTitle 3', description: 'Description 3', link: 'link3', guid: 'guid3'),
  RssItem(title: 'ItemTitle 4', description: 'Description 4', link: 'link4', guid: 'guid4'),
  RssItem(title: 'ItemTitle 5', description: 'Description 5', link: 'link5', guid: 'guid5'),
  RssItem(title: 'ItemTitle 6', description: 'Description 6', link: 'link6', guid: 'guid6'),
];

RssFeed feed = RssFeed(items: fakeRssItems);
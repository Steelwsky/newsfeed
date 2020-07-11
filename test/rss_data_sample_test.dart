import 'package:webfeed/webfeed.dart';

List<RssItem> fakeRssItems = [
  RssItem(title: 'ItemTitle1', description: 'Description 1', link: 'link1', guid: 'guid1'),
  RssItem(title: 'ItemTitle2', description: 'Description 2', link: 'link2', guid: 'guid2'),
  RssItem(title: 'ItemTitle3', description: 'Description 3', link: 'link3', guid: 'guid3'),
  RssItem(title: 'ItemTitle4', description: 'Description 4', link: 'link4', guid: 'guid4'),
  RssItem(title: 'ItemTitle5', description: 'Description 5', link: 'link5', guid: 'guid5'),
  RssItem(title: 'ItemTitle6', description: 'Description 6', link: 'link6', guid: 'guid6'),
];

RssFeed feed = RssFeed(items: fakeRssItems);

//List<FeedRssItem> fakeRssItems = [
//  FeedRssItem(
//      item: RssItem(title: 'ItemTitle1', description: 'Description 1', link: 'link1', guid: 'guid1'), isViewed: true),
//  FeedRssItem(
//      item: RssItem(title: 'ItemTitle2', description: 'Description 2', link: 'link2', guid: 'guid2'), isViewed: true),
//  FeedRssItem(
//      item: RssItem(title: 'ItemTitle3', description: 'Description 3', link: 'link3', guid: 'guid3'), isViewed: true),
//  FeedRssItem(
//      item: RssItem(title: 'ItemTitle4', description: 'Description 4', link: 'link4', guid: 'guid4'), isViewed: true),
//  FeedRssItem(
//      item: RssItem(title: 'ItemTitle5', description: 'Description 5', link: 'link5', guid: 'guid5'), isViewed: true),
//  FeedRssItem(
//      item: RssItem(title: 'ItemTitle6', description: 'Description 6', link: 'link6', guid: 'guid6'), isViewed: true),
//];

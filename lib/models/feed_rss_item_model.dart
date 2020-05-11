import 'package:webfeed/webfeed.dart';

class FeedRssItem {
  FeedRssItem({this.item, this.isViewed});

  final RssItem item;
  final bool isViewed;

  FeedRssItem copyWith({bool isViewed}) {
    return FeedRssItem(isViewed: isViewed, item: item);
  }
}

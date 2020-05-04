import 'package:webfeed/webfeed.dart';

class MyRepository {
  List<RssItem> _repositoryItems = [];
  List<String> _repositoryLinks = [];

  void addToHistory(RssItem item) {
    _repositoryItems.add(item);
    _repositoryLinks.add(item.link);
    print('item added');
  }

  bool isViewedItemByLink(String takenLink) {
    return _repositoryLinks.contains(takenLink);
  }

  List<RssItem> getCurrentList() {
    return _repositoryItems;
  }

  List<RssItem> deleteHistory() {
    _repositoryItems = [];
    _repositoryLinks = [];
    return _repositoryItems;
  }
}

class RepositoryItems {
  final RssItem repositoryRssItem;

  RepositoryItems({this.repositoryRssItem});
}

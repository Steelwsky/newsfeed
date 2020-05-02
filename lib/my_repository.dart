import 'package:webfeed/webfeed.dart';

class MyRepository {
  List<RssItem> _repositoryItems = [];

  void addToHistory(RssItem item) {
    _repositoryItems.add(item);
    print('item added');
  }

  bool isViewedItemByLink(String takenLink) {
    bool myBool = false;
    print('isViewedItem');
    for (var i = 0; i < _repositoryItems.length; i++) {
      print('isViewed FOR: $i');
      if (_repositoryItems[i].link == takenLink) {
        print('isViewed IF: $i');
        return myBool = true;
      }
    }
    return myBool;
  }

  List<RssItem> getCurrentList() {
    return _repositoryItems;
  }
}

class RepositoryItems {
  final RssItem repositoryRssItem;

  RepositoryItems({this.repositoryRssItem});
}

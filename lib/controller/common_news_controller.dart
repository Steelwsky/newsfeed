import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:newsfeed/strings.dart';

enum Pages { latest, history }

class MyPageController {
  ValueNotifier<int> pageStateNotifier = ValueNotifier(Pages.latest.index);

  MyPageController({this.pageController});

  final PageController pageController;

  void pageSwipeChange(int pageIndex) {
    pageStateNotifier.value = pageIndex;
  }

  void pageNavBarChange(int pageIndex) {
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 500), curve: Curves.ease);
    pageStateNotifier.value = pageIndex;
  }
}

class BottomNavBarItemModel {
  BottomNavBarItemModel({this.name, this.icon});

  final String name;
  final Icon icon;
}

class BottomNavBarItems {
  List<BottomNavBarItemModel> _tabs;

  BottomNavBarItems() {
    _tabs = [
      BottomNavBarItemModel(name: LATEST, icon: Icon(Icons.home)),
      BottomNavBarItemModel(name: HISTORY, icon: Icon(Icons.history))
    ];
  }

  UnmodifiableListView<BottomNavBarItemModel> get tabs => UnmodifiableListView(_tabs);
}

enum DataSource { cnbc, nytimes }

class RssDataSourceModel {
  RssDataSourceModel({
    this.source,
    this.link,
    this.longName,
    this.shortName,
  });

  final DataSource source;
  final String link;
  final String longName;
  final String shortName;
}

class RssDataSourcesList {
  static List<RssDataSourceModel> _sources;

  RssDataSourcesList() {
    _sources = [
      RssDataSourceModel(
          source: DataSource.cnbc,
          link: 'https://www.cnbc.com/id/100727362/device/rss/rss.html',
          longName: 'CNBC International',
          shortName: 'CNBC'),
      RssDataSourceModel(
          source: DataSource.nytimes,
          link: 'https://www.nytimes.com/svc/collections/v1/publish/https://www.nytimes.com/section/world/rss.xml',
          longName: 'The New York Times',
          shortName: 'NY Times'),
    ];
  }

  UnmodifiableListView<RssDataSourceModel> get sources => UnmodifiableListView(_sources);
}

class RssDataSourceController {
  static RssDataSourcesList rssDataSources = RssDataSourcesList();
  ValueNotifier<RssDataSourceModel> rssDataSourceNotifier = ValueNotifier(rssDataSources.sources.first);
  final sourcesList = rssDataSources.sources;

  void changingDataSource(int index) {
    rssDataSourceNotifier.value = rssDataSources.sources[index];
  }
}

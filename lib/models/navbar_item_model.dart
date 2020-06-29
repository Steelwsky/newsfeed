import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:newsfeed/constants/strings.dart';

class BottomNavBarItemModel {
  BottomNavBarItemModel({this.name, this.icon});

  final String name;
  final Icon icon;
}

class BottomNavBarItems {
  List<BottomNavBarItemModel> _tabs;

  BottomNavBarItems() {
    _tabs = [
      BottomNavBarItemModel(
          name: LATEST,
          icon: Icon(
            Icons.home,
          )),
      BottomNavBarItemModel(
          name: HISTORY,
          icon: Icon(
            Icons.history,
          )),
      BottomNavBarItemModel(
          name: SEARCH,
          icon: Icon(
            Icons.search,
          )),
    ];
  }

  UnmodifiableListView<BottomNavBarItemModel> get tabs => UnmodifiableListView(_tabs);
}

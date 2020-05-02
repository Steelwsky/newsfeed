import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:newsfeed/strings.dart';

enum Pages { latest, history }

class MyPageController {
  ValueNotifier<int> pageState = ValueNotifier(Pages.latest.index);

  MyPageController({this.pageController});

  final PageController pageController;

  void pageSwipeChange(int pageIndex) {
    pageState.value = pageIndex;
  }

  void pageNavBarChange(int pageIndex) {
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 500), curve: Curves.ease);
    pageState.value = pageIndex;
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

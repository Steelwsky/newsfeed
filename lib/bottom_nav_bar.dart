import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/common_news_controller.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final BottomNavBarItems myBottomNavBarItems = BottomNavBarItems();

  @override
  Widget build(BuildContext context) {
    final myPageController = Provider.of<MyPageController>(context);
    return ValueListenableBuilder<int>(
        valueListenable: myPageController.pageState,
        builder: (_, pageState, __) {
          return BottomNavigationBar(
              items: [
                ...myBottomNavBarItems.tabs.map((tab) => BottomNavigationBarItem(
                      title: Text(tab.name),
                      icon: tab.icon,
                    ))
              ],
              currentIndex: pageState,
              onTap: (index) {
                myPageController.pageNavBarChange(index);
              });
        });
  }
}

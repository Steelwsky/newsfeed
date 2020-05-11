import 'package:flutter/material.dart';

enum Pages { latest, history }

class MyPageController {
  ValueNotifier<int> pageStateNotifier = ValueNotifier(Pages.latest.index);

  MyPageController({this.pageController});

  final PageController pageController;

  void pageSwipeChange(int pageIndex) {
    pageStateNotifier.value = pageIndex;
  }

  void pageNavBarChange(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    pageStateNotifier.value = pageIndex;
  }
}

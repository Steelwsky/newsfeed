import 'package:flutter/material.dart';

//enum Pages { latest, history, search } //seems useless - don't use it anywhere except line 6
const int INITIAL_PAGE = 0;

class MyPageController {
  ValueNotifier<int> pageStateNotifier = ValueNotifier(INITIAL_PAGE);

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

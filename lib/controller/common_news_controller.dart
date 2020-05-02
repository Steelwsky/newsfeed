import 'package:flutter/material.dart';

enum Pages { latest, history }

class MyPageController {
  ValueNotifier<int> pageState = ValueNotifier(Pages.latest.index);

  void pageChange(int pageIndex) {
    pageState.value = pageIndex;
  }
}

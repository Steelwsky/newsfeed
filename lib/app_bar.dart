import 'package:flutter/material.dart';
import 'package:newsfeed/strings.dart';
import 'package:provider/provider.dart';

import 'controller/common_news_controller.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final myPageController = Provider.of<MyPageController>(context);
    return ValueListenableBuilder(
        valueListenable: myPageController.pageState,
        builder: (_, pageState, __) {
          return AppBar(
            title: pageState == 0 ? Text(LATEST) : Text(HISTORY),
          );
        });
  }
}

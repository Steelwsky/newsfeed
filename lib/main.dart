import 'package:flutter/material.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [Provider<MyPageController>(create: (_) => MyPageController())],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: MyHomePage(),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    NewsController newsController = Provider.of<NewsController>(context);
    return AppBar(
      title: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        height: 44,
        width: 270,
        child: TextField(
          controller: _textController,
          autofocus: true,
          maxLines: 1,
          autocorrect: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12),
            fillColor: Colors.white,
            focusColor: Colors.white,
            hintText: "Enter query",
            hintStyle: TextStyle(color: Colors.black38),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print(_textController.value.text);
                newsController.queryForGoogle(query: _textController.value.text);
                print('text for queryForGoogle: ${_textController.value.text}');
                newsController.findItemsBySearch(_textController.value.text);
              },
            ),
          ),
          style: TextStyle(fontSize: 18.0),
          onChanged: (query) => {},
        ),
      ),
//      actions: <Widget>[],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsfeed/search_bloc/search_bloc.dart';
import 'package:newsfeed/search_bloc/search_event.dart';

class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  AnimationController _animationController;
  Animation _containerSizeAnimation;
  SearchBloc _searchBloc;

//  Animation<Offset> _offsetAnimation;
  double _initialFieldWidth = 23; // 276.0 = 23 * 12
  double _initialFieldHeight = 44.0;

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    )..forward();

    _containerSizeAnimation = Tween(begin: 0.0, end: 12.0).animate(CurvedAnimation(
      curve: Curves.decelerate,
      parent: _animationController,
    ));
//    _offsetAnimation = Tween<Offset>(
//      end: Offset.zero,
//      begin: const Offset(1.5, 0.0),
//    ).animate(CurvedAnimation(
//      parent: _animationController,
//      curve: Curves.elasticIn,
//    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    NewsController newsController = Provider.of<NewsController>(context);
//    SearchBloc searchBloc = BlocProvider.of<SearchBloc>(context);
    return AppBar(
        title: AnimatedBuilder(
            animation: _animationController,
            builder: (context, index) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
//                transform: Matrix4.translationValues(0.0, 00.0, 0.0),
                  width: _containerSizeAnimation.value * _initialFieldWidth,
                  height: _initialFieldHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _textController,
                    maxLines: 1,
                    autocorrect: false,
//                    onSubmitted: (str) => newsController.queryAndFind(query: str),
                    onSubmitted: (str) =>
                        _searchBloc.add(
                          SearchInitialized(text: _textController.value.text),
                        ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      hintText: "Enter a query",
                      hintStyle: TextStyle(color: Colors.black38),
                      suffixIcon: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                        child: IconButton(
                            icon: Icon(Icons.search),
//                          onPressed: () => newsController.queryAndFind(query: _textController.value.text),
                            onPressed: () {
                              print(_textController.value.text);
                              _searchBloc.add(
                                SearchInitialized(text: _textController.value.text),
                              );
                            }),
                      ),
                    ),
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              );
            }));
  }
}

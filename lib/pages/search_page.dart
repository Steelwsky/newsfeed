import 'package:flutter/material.dart';
import 'package:newsfeed/constants/strings.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/models/feed_rss_item_model.dart';
import 'package:newsfeed/pages/selected_news_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myNewsController = Provider.of<NewsController>(context);
    return ValueListenableBuilder<List<FeedRssItem>>(
        valueListenable: myNewsController.searchRssItems,
        builder: (_, foundItems, __) {
          if (foundItems == null) {
            return ItemsNotFound();
          }
          return foundItems.isEmpty
              ? InitialEmptySearchList()
              : ListView(
                  key: PageStorageKey('latest'),
                  children: foundItems
                      .toList()
                      .map(
                        (i) => ListTile(
                          title: Text(
                            i.item.title,
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            i.item.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing:
                              Icon(i.isViewed ? Icons.bookmark : Icons.bookmark_border, size: 24, color: Colors.amber),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => SelectedNewsPage(rssItem: i.item)));
                          },
                        ),
                      )
                      .toList());
        });
  }
}

class ItemsNotFound extends StatefulWidget {
  @override
  _ItemsNotFoundState createState() => _ItemsNotFoundState();
}

class _ItemsNotFoundState extends State<ItemsNotFound> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myNewsController = Provider.of<NewsController>(context);
    //TODO
    return ValueListenableBuilder<String>(
        valueListenable: myNewsController.queryForSearch,
        builder: (_, queryString, __) {
          return SlideTransition(
            position: _offsetAnimation,
            child: Container(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 64),
                child: Container(
                  height: 100,
                  width: 300,
                  child: Card(
                    child: InkWell(
                      splashColor: Colors.deepPurple.withAlpha(30),
                      onTap: () async {
                        if (await canLaunch('$SEARCH_GOOGLE${myNewsController.queryForSearch.value}')) {
                          await launch('$SEARCH_GOOGLE${myNewsController.queryForSearch.value}');
                        } else {
                          throw 'Could not launch';
                        }
                      },
                      child: Center(
                        child: Text(
                          'Search in google: "$queryString"',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class InitialEmptySearchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//      AnimatedContainer(
//      duration: Duration(seconds: 1),
//      transform: Matrix4.identity()
//        ..setEntry(2, 1, 0.003)
//        ..rotateX(pi / 4),

import 'package:flutter/material.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/models/feed_rss_item_model.dart';
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
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => null));
                          },
                        ),
                      )
                      .toList());
        });
  }
}

class ItemsNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myNewsController = Provider.of<NewsController>(context);
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 64),
        child: Card(
          child: InkWell(
            splashColor: Colors.deepPurple.withAlpha(30),
            onTap: () async {
              if (await canLaunch(myNewsController.queryForSearch.value)) {
                await launch(myNewsController.queryForSearch.value);
              } else {
                throw 'Could not launch';
              }
            },
            child: Container(
              width: 300,
              height: 100,
              child: Center(
                child: Text(
                  'Search in google!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InitialEmptySearchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

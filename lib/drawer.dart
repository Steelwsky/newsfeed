import 'package:flutter/material.dart';
import 'package:newsfeed/strings.dart';
import 'package:provider/provider.dart';

import 'controller/common_news_controller.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsController = Provider.of<NewsController>(context);
    return Drawer(
      key: ValueKey('drawer'),
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            height: 108,
            child: DrawerHeader(
              child: Text(
                SELECT_NEWS_SOURCE,
                style: TextStyle(color: Colors.white, fontSize: 21),
              ),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              ListView.builder(
                  padding: EdgeInsets.only(top: 0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: newsController
                      .getDataSource()
                      .length,
                  itemBuilder: (BuildContext _, int index) {
                    return MyInkWellRadio(
                      indx: index,
//                      myDataSourceController: newsController,
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

class MyInkWellRadio extends StatelessWidget {
  MyInkWellRadio({this.indx});

  final int indx;

//  final RssDataSourceController myDataSourceController;

  @override
  Widget build(BuildContext context) {
    final newsController = Provider.of<NewsController>(context);
    return ValueListenableBuilder<RssDataSourceModel>(
        valueListenable: newsController.rssDataSourceNotifier,
        builder: (_, rssDataSourceState, __) {
          return InkWell(
            child: ListTile(
              key: ValueKey('${newsController.getDataSource()[indx].shortName}'),
              title: Text(
                newsController.getDataSource()[indx].longName,
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(
                  rssDataSourceState == newsController.getDataSource()[indx]
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Colors.deepOrange),
            ),
            onTap: () {
              Navigator.pop(context);
              newsController.changingDataSource(newsController.getDataSource()[indx].source);
              newsController.fetchNews(link: newsController.getDataSource()[indx].link);
            },
          );
        });
  }
}

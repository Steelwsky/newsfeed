import 'package:flutter/material.dart';
import 'package:newsfeed/strings.dart';
import 'package:provider/provider.dart';

import 'controller/common_news_controller.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myDataSourceController = Provider.of<RssDataSourceController>(context);
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
                  itemCount: myDataSourceController.sourcesList.length,
                  itemBuilder: (BuildContext _, int index) {
                    return MyInkWellRadio(
                      indx: index,
                      myDataSourceController: myDataSourceController,
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
  MyInkWellRadio({this.indx, this.myDataSourceController});

  final int indx;
  final RssDataSourceController myDataSourceController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RssDataSourceModel>(
        valueListenable: myDataSourceController.rssDataSourceNotifier,
        builder: (_, rssDataSourceState, __) {
          return InkWell(
            child: ListTile(
              key: ValueKey('${myDataSourceController.sourcesList[indx].shortName}'),
              title: Text(
                myDataSourceController.sourcesList[indx].longName,
                style: TextStyle(fontSize: 18),
              ),
              trailing: Icon(
                  rssDataSourceState == myDataSourceController.sourcesList[indx]
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: Colors.deepOrange),
            ),
            onTap: () {
              Navigator.pop(context);
              myDataSourceController.changingDataSource(indx);
            },
          );
        });
  }
}

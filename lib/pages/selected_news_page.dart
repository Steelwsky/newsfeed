import 'package:flutter/material.dart';
import 'package:newsfeed/constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';

class SelectedNewsPage extends StatelessWidget {
  SelectedNewsPage({Key key, this.rssItem}) : super(key: key);
  final RssItem rssItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(rssItem.title),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        rssItem.description,
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        height: 50,
                        width: 174,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: InkWell(
                              onTap: () async {
                                if (await canLaunch(rssItem.link)) {
                                  await launch(rssItem.link);
                                } else {
                                  throw 'Could not launch ${rssItem.link}';
                                }
                              },
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      CONTINUE_READING,
                                      style: (TextStyle(fontSize: 20)),
                                    ),
                                  ),
                                  Icon(Icons.open_in_new, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            )
          ],
        ));
  }
}

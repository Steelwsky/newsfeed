import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsfeed/constants/strings.dart';
import 'package:newsfeed/models/feed_rss_item_model.dart';
import 'package:newsfeed/pages/selected_news_page.dart';
import 'package:newsfeed/search_bloc/search_bloc.dart';
import 'package:newsfeed/search_bloc/search_state.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: BlocProvider.of<SearchBloc>(context),
      builder: (BuildContext _, SearchState state) {
        if (state is SearchEmptyResult) {
          return ItemsNotFound(
            query: state.query,
          );
        }
        if (state is SearchLoading) {
          return CircularProgressIndicator();
        }
        if (state is SearchSuccess) {
          return SearchResultsList(searchResults: state.items);
        }
        return InitialEmptySearchList();
      },
    );
  }
}

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({
    @required this.searchResults,
    Key key,
  }) : super(key: key);

  final List<FeedRssItem> searchResults;

  @override
  Widget build(BuildContext context) {
    return ListView(
        key: PageStorageKey('latest'),
        children: searchResults
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
                trailing: Icon(i.isViewed ? Icons.bookmark : Icons.bookmark_border, size: 24, color: Colors.amber),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => SelectedNewsPage(rssItem: i.item)));
                },
              ),
            )
            .toList());
  }
}

class ItemsNotFound extends StatefulWidget {
  ItemsNotFound({this.query});

  final String query;

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
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
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
    return SlideTransition(
      position: _offsetAnimation,
      child: Column(
        children: <Widget>[
          Card(
            child: InkWell(
              splashColor: Colors.deepPurple.withAlpha(30),
              onTap: () async {
                if (await canLaunch('$SEARCH_GOOGLE${widget.query}')) {
                  await launch('$SEARCH_GOOGLE${widget.query}');
                } else {
                  throw 'Could not launch';
                }
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Not found here\n\nSearch in google: "${widget.query}"',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
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

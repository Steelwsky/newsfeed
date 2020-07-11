import 'package:equatable/equatable.dart';
import 'package:newsfeed/models/feed_rss_item_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<FeedRssItem> items;

  const SearchSuccess(this.items);

  @override
  List<Object> get props => [items];
}

class SearchEmptyResult extends SearchState {
  final String query;

  SearchEmptyResult({this.query});

  @override
  List<Object> get props => [query];
}

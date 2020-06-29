import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsfeed/search_bloc/search_state.dart';

import 'search_event.dart';

//state: List<FeedRssItem>
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  @override
  get initialState => null;

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchCompleted) {}
    yield null;
  }
}

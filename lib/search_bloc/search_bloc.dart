import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsfeed/controller/common_news_controller.dart';
import 'package:newsfeed/search_bloc/search_state.dart';

import 'search_event.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({@required this.newsController});

  final NewsController newsController;

  @override
  get initialState => SearchInitial();

  @override
  void onTransition(Transition<SearchEvent, SearchState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchInitialized) {
      final String searchItem = event.text;
      yield SearchLoading();
      final results = await newsController.searchBloc(query: searchItem);
      print('RESULTS: ${results.length}');
      if (results.isEmpty) {
        yield SearchEmptyResult();
      } else
        yield SearchSuccess(results);
    }
  }
}

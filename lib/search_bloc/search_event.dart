import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchInitialized extends SearchEvent {
  const SearchInitialized({this.text});

  final String text;

  @override
  List<Object> get props => [text];
}

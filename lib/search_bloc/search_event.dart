import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchStarted extends SearchEvent {
  final String text;

  const SearchStarted({this.text});

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'TextChanged { text: $text }';
}

class SearchCompleted extends SearchEvent {
  @override
  List<Object> get props => null;
}

class SearchFoundNothing extends SearchEvent {
  @override
  List<Object> get props => null;
}

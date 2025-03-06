part of 'characters_cubit.dart';

sealed class CharactersState {}

final class CharactersInitial extends CharactersState {}

final class CharactersLoaded extends CharactersState {
  final CharactersModel characters;

  CharactersLoaded(this.characters);
}

final class QuotesLoaded extends CharactersState {
  final QuotesModel quotesModel;

  QuotesLoaded(this.quotesModel);
}

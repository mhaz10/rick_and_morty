
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/data/models/characters.dart';
import 'package:rick_and_morty/data/models/quotes.dart';
import 'package:rick_and_morty/data/repository/characters_repository.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  CharactersModel? charactersModel;

  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  void getAllCharacters({int? page}) {
    charactersRepository.getAllCharacters(page: page).then((characters) {
      emit(CharactersLoaded(characters));
      charactersModel = characters;
    });
  }

  void getQuotes() {
    charactersRepository.getQuotes().then((quotes) {
      emit(QuotesLoaded(quotes));
    });
  }


}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rick_and_morty/data/models/characters.dart';
import 'package:rick_and_morty/data/models/quotes.dart';
import 'package:rick_and_morty/data/repository/characters_repository.dart';
import 'package:rick_and_morty/data/web_services/characters_web_services.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  List<Result> characters = [];
  CharactersModel? charactersModel;

  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  List<Result> getAllCharacters() {
    charactersRepository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    });

    return characters;
  }

  // void getAllCharactersModel({String? page}) async {
  //   charactersRepository.getAllCharactersModel(page: page).then((charactersModel) {
  //     emit(CharactersModelLoaded(charactersModel));
  //     this.charactersModel = charactersModel;
  //   });
  // }

  void getQuotes() {
    charactersRepository.getQuotes().then((quotes) {
      emit(QuotesLoaded(quotes));
    });
  }


}

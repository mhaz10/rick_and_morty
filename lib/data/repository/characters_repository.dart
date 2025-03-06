import 'package:rick_and_morty/data/models/characters.dart';
import 'package:rick_and_morty/data/models/quotes.dart';
import 'package:rick_and_morty/data/web_services/characters_web_services.dart';

class CharactersRepository {
  final CharactersWebServices charactersWebServices;

  CharactersRepository(this.charactersWebServices);

  Future<CharactersModel> getAllCharacters({int? page}) async {
    final response = await charactersWebServices.getAllCharacters(page: page);
    return CharactersModel.fromJson(response);
  }

  Future<QuotesModel> getQuotes() async {
    final response = await charactersWebServices.getQuotes();
    return QuotesModel.fromJson(response);
  }
}
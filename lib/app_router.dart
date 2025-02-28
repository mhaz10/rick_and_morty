import 'package:flutter/material.dart';
import 'package:rick_and_morty/constants/strings.dart';
import 'package:rick_and_morty/presention/screens/character_details.dart';
import 'package:rick_and_morty/presention/screens/characters_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
      return MaterialPageRoute(builder: (_) => const CharactersScreen());

      case characterDetailsScreen:
        return MaterialPageRoute(builder: (_) => const CharacterDetails());
    }
  }
}
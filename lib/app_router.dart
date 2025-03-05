import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/business_logic/cubit/characters_cubit.dart';
import 'package:rick_and_morty/constants/strings.dart';
import 'package:rick_and_morty/data/models/characters.dart';
import 'package:rick_and_morty/data/repository/characters_repository.dart';
import 'package:rick_and_morty/data/web_services/characters_web_services.dart';
import 'package:rick_and_morty/presention/screens/character_details_screen.dart';
import 'package:rick_and_morty/presention/screens/characters_screen.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepository = CharactersRepository(CharactersWebServices());
    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(builder: (_) =>
            BlocProvider(
              create: (context) => CharactersCubit(charactersRepository),
              child: CharactersScreen(),
            ));

      case characterDetailsScreen:
        final character = settings.arguments as Result;
        return MaterialPageRoute(builder: (_) =>
            BlocProvider(
              create: (context) => CharactersCubit(charactersRepository),
              child: CharacterDetailsScreen(character: character),
            ));
    }
  }
}
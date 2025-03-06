import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:rick_and_morty/business_logic/cubit/characters_cubit.dart';
import 'package:rick_and_morty/constants/my_colors.dart';
import 'package:rick_and_morty/data/models/characters.dart';
import 'package:rick_and_morty/presention/widgets/character_item.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  
  late CharactersModel allCharacters;
  late List<Result> searchedCharacters;
  bool isSearching = false;
  final searchTextController = TextEditingController();
  int page = 1;

  Widget buildSearchField() {
    return TextField(
      controller: searchTextController,
      cursorColor: MyColors.myGrey,
      decoration: InputDecoration(
        hintText: 'Find a character .......',
        hintStyle: TextStyle(color: MyColors.myGrey, fontSize: 18),
        border: InputBorder.none,
      ),
      style: TextStyle(color: MyColors.myGrey, fontSize: 18),
      onChanged: (searchedCharacter) {
        addSearchedCharactersToList(searchedCharacter);
      },
    );
  }

  void addSearchedCharactersToList(String searchedCharacter) {
    searchedCharacters = allCharacters.results.where((character) =>
        character.name!.toLowerCase().startsWith(searchedCharacter.toLowerCase())).toList();
    setState(() {});
  }

  List<Widget> buildAppBarActions () {
    if (isSearching) {
      return [
        IconButton(onPressed: () {
          clearSearch();
          Navigator.pop(context);
        }, icon: Icon(Icons.clear, color: MyColors.myGrey,)),
      ];
    } else {
      return [
        IconButton(onPressed: startSearch, icon: Icon(Icons.search, color: MyColors.myGrey,)),
      ];
    }
  }

  void startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearch));

    setState(() {
      isSearching = true;
    });
  }

  void stopSearch() {
    clearSearch();

    setState(() {
      isSearching = false;
    });
  }


  void clearSearch() {
    setState(() {
      searchTextController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }
  
  Widget buildBlocWidget () {
    return BlocBuilder<CharactersCubit, CharactersState>(builder: (context, state) {
      if (state is CharactersLoaded) {
          allCharacters = state.characters;
          return buildLoadedListWidgets();
      } else {
        return showLoadingIndicator();
      }
    });
  }

  Widget showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [
            buildCharactersList(),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (page > 0) {
                      page --;
                      BlocProvider.of<CharactersCubit>(context).getAllCharacters(page: page);
                    }


                    setState(() {

                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.white,),
                      Text('prev', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
                SizedBox(width: 50,),
                GestureDetector(
                  onTap: () {
                    page ++;

                    BlocProvider.of<CharactersCubit>(context).getAllCharacters(page: page);

                    setState(() {

                    });
                  },
                  child: Row(
                    children: [
                      Text('next', style: TextStyle(color: Colors.white),),
                      Icon(Icons.arrow_forward_ios, color: Colors.white,),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  Widget buildCharactersList() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            childAspectRatio: 2/3),

        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.zero,

        itemCount: searchTextController.text.isEmpty ? allCharacters.results.length : searchedCharacters.length,
        itemBuilder: (context, index) => CharacterItem(character: searchTextController.text.isEmpty ? allCharacters.results[index] : searchedCharacters[index]),);
  }

  Widget buildAppBarTitle () {
    return Text('Characters', style: TextStyle(color: MyColors.myGrey),);
  }


  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Text('Can\'t connect ... check internet', style: TextStyle(fontSize: 22, color: MyColors.myGrey),),
            Image.asset('assets/images/no_internet.png'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        leading: isSearching ? BackButton(color: MyColors.myGrey,) : null,
        title: isSearching ? buildSearchField() : buildAppBarTitle(),
        actions: buildAppBarActions(),
      ),
      
      body: OfflineBuilder(
        connectivityBuilder: (
        BuildContext context, List<ConnectivityResult> connectivity, Widget child,)
        {
          final bool connected = !connectivity.contains(ConnectivityResult.none);

          if (connected) {
            return buildBlocWidget();
          } else {
            return buildNoInternetWidget();
          }
        },
        child: Center(child: showLoadingIndicator()),
      ),
    );
  }
}

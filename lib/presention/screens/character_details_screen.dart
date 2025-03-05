import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/business_logic/cubit/characters_cubit.dart';
import 'package:rick_and_morty/constants/my_colors.dart';
import 'package:rick_and_morty/data/models/characters.dart';

class CharacterDetailsScreen extends StatefulWidget {
  final Result character;

  const CharacterDetailsScreen({super.key, required this.character});

  @override
  State<CharacterDetailsScreen> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen> {
  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        //centerTitle: true,
        title: Text(widget.character.name!, style: TextStyle(color: MyColors.myYellow, fontWeight: FontWeight.bold),),
        background: Hero(
            tag: widget.character.id as Object,
            child: Image.network(widget.character.image, fit: BoxFit.cover)),
      ),
    );
  }

  Widget characterInfo (String title, String value) {
    return RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: TextStyle(
                color: MyColors.myWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )
            ),

            TextSpan(
                text: value,
                style: TextStyle(
                  color: MyColors.myWhite,
                  fontSize: 16,
                )
            )
          ]
        )
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      color: MyColors.myYellow,
      height: 30,
      endIndent: endIndent,
      thickness: 2,
    );
  }

  Widget checkIfQuotesLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return displayRandomQuoteOrEmptySpace(state);
    } else {
      return showProgressIndicator();
    }
  }

  Widget displayRandomQuoteOrEmptySpace(CharactersState state) {
    var quotes = (state as QuotesLoaded).quotesModel.quote;
    if (quotes.isNotEmpty) {
      return DefaultTextStyle(
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: MyColors.myWhite,
          shadows: [
            Shadow(
              blurRadius: 7,
              color: MyColors.myYellow,
              offset: Offset(0, 0)
            )
          ]
        ),
        child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText(quotes),
            ]
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget showProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(delegate: SliverChildListDelegate(
            [
              Container(
                margin: EdgeInsetsDirectional.fromSTEB(14, 14, 14, 0),
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    characterInfo('Status : ', widget.character.status!),
                    buildDivider(315),
                    characterInfo('Species : ', widget.character.species!),
                    buildDivider(315),
                    if (widget.character.type!.isNotEmpty) ...[
                      characterInfo('Type : ', widget.character.type!),
                      buildDivider(315),
                    ],
                    characterInfo('Gender : ', widget.character.gender!),
                    buildDivider(315),
                    characterInfo('Origin : ', widget.character.origin!.name!),
                    buildDivider(315),
                    characterInfo('Location : ', widget.character.location!.name!),
                    buildDivider(315),

                    SizedBox(height: 20,),

                    BlocBuilder<CharactersCubit, CharactersState>(
                        builder: (context, state) {
                          return checkIfQuotesLoaded(state);
                    })
                  ],
                ),
              ),
              SizedBox(height: 500,)
            ]
          ))
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hangman/files/storage.dart';
import 'package:hangman/screens/game.dart';
import 'package:hangman/settings/settings.dart';
import 'package:hangman/settings/translator.dart';
import 'package:hangman/widgets/navigation/app_bar.dart';
import 'package:hangman/widgets/navigation/menu_buttons.dart';
import 'package:hangman/widgets/selection/dropdown.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

FileManager storage = FileManager();

class _HomeState extends State<Home> {
  Category category = Category.general;
  Country country = Country.gb;
  Translator translator = Settings.getTranslator(Country.gb);

  @override
  void initState() {
    super.initState();

    translator = Settings.getTranslator(country);
    storage.readJsonFile().then((value) {
      Country countryFromStorage = Settings.getCountry(value['country']);

      setState(() {
        country = countryFromStorage;
        category = Settings.getCategory(value['category']);
        translator = Settings.getTranslator(countryFromStorage);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: _body(),
    );
  }

  Widget _body() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _gameHero(),
            _title(),
            _selectors(),
            _menuButtons(),
          ],
        ),
      );

  Widget _gameHero() => Hero(
        tag: 'hero-avatar',
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 80,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset('assets/images/doodle-1/main.png'),
          ),
        ),
      );

  Widget _title() => Text(
        '${translator.title}:\n${translator.subtitle}',
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      );

  Widget _selectors() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Dropdown(
              items: [
                ['general', translator.general],
                ['business', translator.business],
                ['entertainment', translator.entertainment],
                ['science', translator.science],
                ['health', translator.health],
                ['sport', translator.sport]
              ],
              value: category.toString().split('.').last,
              onSelect: _updateCategory),
          Dropdown(
              items: [
                ['gb', 'English (UK)'],
                ['us', 'English (US)'],
                ['de', 'Deutsch'],
                ['nl', 'Nederlands'],
                ['pl', 'Polski']
              ],
              value: country.toString().split('.').last,
              onSelect: _updateCountry),
        ],
      );

  void _updateCategory(String val) {
    setState(() {
      category = Settings.getCategory(val);
    });

    // TODO: Change func name
    storage.writeJsonFile(val, country.toString().split('.').last);
  }

  void _updateCountry(String val) {
    Country newCountry = Settings.getCountry(val);

    setState(() {
      country = newCountry;
      translator = Settings.getTranslator(newCountry);
    });

    storage.writeJsonFile(category.toString().split('.').last, val);
  }

  Widget _menuButtons() => menuButtons(context, [
        new MenuButtonData(translator.play, _onPlay),
        new MenuButtonData(translator.leaderboard, _onLeaderboard),
        new MenuButtonData(translator.exit, _onExit),
      ]);

  _onPlay() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Game(storage: storage, translator: translator, country: country, category: category,)));
  }

  _onLeaderboard() {
    // TODO:
  }

  _onExit() {
    // TODO:
  }
}

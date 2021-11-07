import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:hangman/pages/game.dart';
import 'package:hangman/settings/settings.dart';
import 'package:hangman/files/storage.dart';
import 'package:hangman/components/dropdown.dart';
import 'package:hangman/settings/translator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

FileManager storage = FileManager();
Translator translator = Settings.translator();

class _HomeState extends State<Home> {
  Category category = Category.general;
  Country country = Country.gb;

  @override
  void initState() {
    super.initState();

    storage.readJsonFile().then((value) {
      Settings.category = getCategory(value['category']);
      Settings.country = getCountry(value['country']);
      print('INITIALIZE HOME PAGE');

      setState(() {
        country = Settings.country;
        category = Settings.category;
        translator = Settings.translator();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }

  // UI elements
  PreferredSizeWidget appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actionsIconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        IconButton(icon: Icon(Icons.account_circle), onPressed: () {})
      ],
    );
  }

  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          hero(),
          title(),
          selectors(),
          menuButtons(),
        ],
      ),
    );
  }

  Widget hero() {
    return Hero(
      tag: 'hero-avatar',
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 80,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset('images/doodle-1/main.png'),
        ),
      ),
    );
  }

  Widget title() {
    return Text(
      _getName(),
      style: Theme.of(context).textTheme.headline5,
      textAlign: TextAlign.center,
    );
  }

  Widget selectors() {
    void _updateCategory(String val) {
      Settings.category = getCategory(val);
      storage.writeJsonFile(val, Settings.country.toString().split('.').last);
    }

    void _updateCountry(String val) {
      Country c = getCountry(val);
      Settings.country = c;

      setState(() {
        country = c;
        translator = Settings.translator();
      });

      storage.writeJsonFile(Settings.category.toString().split('.').last, val);
    }

    return Row(
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
        Dropdown(items: [
          ['gb', 'English (UK)'],
          ['us', 'English (US)'],
          ['de', 'Deutsch'],
          ['nl', 'Nederlands'],
          ['pl', 'Polski']
        ], value: country.toString().split('.').last, onSelect: _updateCountry),
      ],
    );
  }

  Widget menuButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        children: <Widget>[
          menuButton(translator.play, _onPlay),
          menuButton(translator.leaderboard, _onLeaderboard),
          menuButton(translator.exit, _onExit),
        ],
      ),
    );
  }

  Widget menuButton(String name, onPressed) => SizedBox(
        width: 300.0,
        height: 60.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(
              name,
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ),
      );

  _getName() {
    return '${translator.title}:\n${translator.subtitle}';
  }

  _onPlay() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Game(storage: storage, translator: translator)));
  }

  _onLeaderboard() {}

  _onExit() {}
}

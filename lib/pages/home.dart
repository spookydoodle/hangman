import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hangman/settings/settings.dart';
import 'package:hangman/settings/storage.dart';
import 'package:hangman/ui/dropdown.dart';

import './game.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

FileManager storage = FileManager();

class _HomeState extends State<Home> {
  var name = 'Hangman:\nGuess The News';
  Category category = Category.general;
  Country country = Country.gb;

  @override
  void initState() {
    super.initState();

    storage.readJsonFile().then((value) {
      Settings.category = getCategory(value['category']);
      Settings.country = getCountry(value['country']);

      setState(() {
        country = Settings.country;
        category = Settings.category;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actionsIconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {})
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Main avatar / logo of the game
            Hero(
              tag: 'hero-avatar',
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 80,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset('images/doodle-1/main.png'),
                ),
              ),
            ),
            //  Game Name
            Text(
              name,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            // Selectors
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dropdown(
                    items: ['general', 'business', 'entertainment', 'science', 'health', 'sport'],
                    value: category.toString().split('.').last,
                    onSelect: _updateCategory),
                Dropdown(
                    items: ['gb', 'us', 'de', 'nl', 'pl'],
                    value: country.toString().split('.').last,
                    onSelect: _updateCountry),
              ],
            ),
            //  Menu Item List
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: <Widget>[
                  navButton("Play", _onPlay),
                  navButton("Leaderboard", _onLeaderboard),
                  navButton("Exit", _onExit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateCategory(String val) {
    Settings.category = getCategory(val);
    storage.writeJsonFile(val, Settings.country.toString().split('.').last);
  }

  void _updateCountry(String val) {
    Settings.country = getCountry(val);
    storage.writeJsonFile(Settings.category.toString().split('.').last, val);
  }

  Widget navButton(String name, onPressed) => SizedBox(
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

  _onPlay() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Game(storage: storage)));
  }

  _onLeaderboard() {}

  _onExit() {}
}
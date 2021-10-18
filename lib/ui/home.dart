import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hangman/settings/settings.dart';
import 'package:hangman/settings/storage.dart';

import 'game.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

FileManager storage = FileManager();

class _HomeState extends State<Home> {
  var name = 'Hangman:\nGuess The News';
  String country = Settings.country;
  String category = Settings.category;

  @override
  void initState() {
    super.initState();

    storage.readJsonFile().then((value) {
      print('PRINTING JSON');
      Settings.category = value['category'];
      Settings.country = value['country'];
      print(Settings.category);
      print(Settings.country);

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
                    value: category,
                    onSelect: _updateCategory),
                Dropdown(
                    items: ['gb', 'us', 'de', 'nl', 'pl'],
                    value: country,
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
    Settings.category = val;
    storage.writeJsonFile(val, Settings.country);
  }

  void _updateCountry(String val) {
    Settings.country = val;
    storage.writeJsonFile(Settings.category, val);
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

/// This is the stateful widget that the main application instantiates.
class Dropdown extends StatefulWidget {
  Dropdown(
      {Key? key,
      required this.items,
      required this.value,
      required this.onSelect})
      : super(key: key);

  final List<String> items;
  String value;
  final void Function(String) onSelect;

  @override
  State<Dropdown> createState() => _DropdownState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.value,
      iconSize: 24,
      elevation: 16,
      style: Theme.of(context).textTheme.bodyText2,
      onChanged: (String? newValue) {
        setState(() {
          widget.value = newValue!;
          widget.onSelect(newValue);
        });
      },
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

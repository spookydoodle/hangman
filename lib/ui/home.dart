import 'dart:ui';

import 'package:flutter/material.dart';

import 'game.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var name = 'Hangman:\nGuess The News';

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
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 80,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('images/doodle-1/main.png'),
              ),
            ),
            //  Game Name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                name,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
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

  Widget navButton(String name, onPressed) => SizedBox(
    width: 300.0,
    height: 60.0,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          name,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
      ),
    ),
  );

  _onPlay() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Game()));
  }

  _onLeaderboard() {
  }

  _onExit() {

  }

}
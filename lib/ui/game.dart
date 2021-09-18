import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final List _alphabet = ['ABCDEFG', 'HIJKLMN', 'OPQRSTU', 'VWXYZ'];
  List _usedLetters = [];
  List _wrongLetters = [];

  final int _maxMistakesFrom = 3;
  final int _maxMistakesTo = 7;

  final List mistakeImages = [
    Image.asset('images/doodle-1/wrong_0.png'),
    Image.asset('images/doodle-1/wrong_1.png'),
    Image.asset('images/doodle-1/wrong_2.png'),
    Image.asset('images/doodle-1/wrong_3.png'),
    Image.asset('images/doodle-1/wrong_4.png'),
    Image.asset('images/doodle-1/wrong_5.png'),
    Image.asset('images/doodle-1/wrong_6.png'),
  ];

  // Get from https://felidae.spookydoodle.com/news/${category}?lang=${lang}&sortBy=timestamp desc&page=${page}
  // category = { general, business, sport, entertainment, health, science
  // lang = { en (gb), en (us), de, nl, pl }
  // Create object in memory to store id's which user was already processed (shown to guess or rejected due to length)
  //
  List keywords = [
    "China's performing arts association bans agent services for minors",
    "One stunning afternoon: Setbacks imperil Biden’s reset",
    "Bigg Boss OTT Finale : Pratik Sehajpal Accepts Money Bag & Quits The Show, Becomes First Contestant Of Bigg Boss 15?",
    "Heavy police presence in Washington ahead of rally for Capitol riot defendants",
    "Prince Charles's former harpist to show off her skills at free poetry show in Portsmouth",
    "Life sciences startups in Eastern Washington find a welcoming ecosystem away from big cities",
    "5G for the enterprise: A status check",
    "Govt to re-look into provisions of Coffee Act and simplify it: Piyush Goyal",
    "Trump reportedly called North Korean leader Kim Jong Un 'a fucking lunatic': book",
    "Don't Wait for a Market Crash: These 2 Top Stocks Are on Sale",
  ];

  // List keywords = [
  //   "Woman's pet dog found dead in freezer at Livingston home",
  // ];

  int wonGames;

  int keywordIndex;
  String keyword;

  int maxMistakes;

  bool gameOver = false;
  int mistakeIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Shuffle the keywords list
    keywords.shuffle();

    //  Assign random keyword
    keywordIndex = -1;
    _nextKeyword();
    wonGames = 0;
  }

  @override
  Widget build(BuildContext context) {
    print('NEW GAME ' + maxMistakes.toString());
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 60.0, left: 20.0, right: 20.0, bottom: 40.0),
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Text('Won games: $wonGames'),
                  Text('Remaining guesses: ${maxMistakes - mistakeIndex}'),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      height: 120,
                      width: 120,
                      child: Stack(
                        children: <Widget>[
                          mistakeIndex > 0 && mistakeIndex <= _maxMistakesTo
                              ? Image.asset('images/doodle-1/wrong_0.png')
                              : Text(''),
                          mistakeIndex > 1 && mistakeIndex <= _maxMistakesTo
                              ? mistakeImages[mistakeIndex - 1]
                              : Text(''),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(_replaceChar(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1),
              Spacer(),
              Container(
                child: Column(
                  children: <Widget>[
                    ..._alphabet.map((row) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ...row.split('').map((char) => _getButton(
                                char,
                                Text(
                                  char.toString().toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                        color: _wrongLetters.contains(char)
                                            ? Theme.of(context).accentColor
                                            : (_usedLetters.contains(char)
                                                ? Colors.grey
                                                : null),
                                        decoration: _usedLetters.contains(char)
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                ),
                                () => _checkLetter(char)))
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _replaceChar() {
    var keywordCopy = [...keyword.split('')].join('').toUpperCase();
    _alphabet.join('').split('').forEach((char) {
      if (!_usedLetters.contains(char)) {
        keywordCopy = keywordCopy.replaceAll(char, '_');
      }
    });

    return keywordCopy;
  }

  void _checkLetter(String char) {
    if (!gameOver) {
      setState(() {
        _usedLetters.add(char);
      });
    }

    if (keyword.contains(char)) {
      _onCorrect();
    } else {
      _onMistake(char);
    }
  }

  void _onCorrect() {
    if (_replaceChar() == keyword) {
      _setGameOver(true);
      print("You won");
      // TODO: Display message and then run _nextKeyword()
      _increaseWonGames();
      _nextKeyword();
    }
  }

  // Increase index and if reached the max allowed mistakes end the game and reset index
  void _onMistake(String char) {
    if (!gameOver) {
      if (!_wrongLetters.contains(char)) {
        _wrongLetters.add(char);
        _increaseMistakeIndex();
      }
    }

    if (mistakeIndex == maxMistakes) {
      _setGameOver(true);
      _resetMistakeIndex();
    }
  }

  void _increaseMistakeIndex() {
    mistakeIndex++;
  }

  void _increaseWonGames() {
    wonGames++;
  }

  void _setGameOver(bool b) {
    gameOver = b;
  }

  void _resetMistakeIndex() {
    mistakeIndex = 0;
  }

  void _increaseKeywordIndex() {
    keywordIndex++;
  }

  void _selectKeyword() {
    keyword = keywords[keywordIndex % keywords.length].toString().toUpperCase();
  }

  void _resetAlphabet() {
    _usedLetters = [];
    _wrongLetters = [];
  }

  void _nextKeyword() {
    setState(() {
      _resetMistakeIndex();
      _increaseKeywordIndex();
      _selectKeyword();
      _setMaxMistakes();
      _resetAlphabet();
      _setGameOver(false);
    });
  }

  // Adjust maxMistakes based on number of unique characters in the headline
  void _setMaxMistakes() {
    print('Getting max for ' + keyword + ' ' + keywordIndex.toString());
    final int factor = 2;
    final String alphabetStr = _alphabet.join('');
    final int alphabetLen = alphabetStr.length;

    int uniqueCharLen = keyword.replaceAll(' ', '').split('').toSet().toList().where((char) => alphabetStr.contains(char.toUpperCase())).length;

    int maxUniqueN = alphabetLen - (_maxMistakesFrom * factor);
    int minUniqueN = alphabetLen - (_maxMistakesTo * factor);

    if (uniqueCharLen > maxUniqueN) {
      _increaseKeywordIndex();
      _nextKeyword();
      print('SKIPPING ' + keyword + ' ' + uniqueCharLen.toString());
      return;
    }

    maxMistakes = uniqueCharLen < minUniqueN ? _maxMistakesTo : ((alphabetLen - uniqueCharLen) / factor).floor();
    print(uniqueCharLen < minUniqueN ? 'SHORT' + uniqueCharLen.toString() : 'OK ' + ((alphabetLen - uniqueCharLen) / factor).floor().toString() + ' ' + uniqueCharLen.toString() + ' ' + minUniqueN.toString() + ' ' + maxUniqueN.toString() + alphabetLen.toString());
  }

  _getButton(String char, Text text, void Function() onPressed) =>
      _usedLetters.contains(char)
          ? OutlinedButton(
              onPressed: onPressed,
              child: text,
            )
          : ElevatedButton(
              onPressed: onPressed,
              child: text,
            );
}

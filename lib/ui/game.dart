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

  final List mistakeImages = [
    Image.asset('images/doodle-1/wrong_0.png'),
    Image.asset('images/doodle-1/wrong_1.png'),
    Image.asset('images/doodle-1/wrong_2.png'),
    Image.asset('images/doodle-1/wrong_3.png'),
    Image.asset('images/doodle-1/wrong_4.png'),
    Image.asset('images/doodle-1/wrong_5.png'),
    Image.asset('images/doodle-1/wrong_6.png'),
  ];

  List keywords = [
    "Cities urge people to stay home on Dutch king's birthday",
    "Global rights group accuses Israel of apartheid, persecution",
    "Private Florida school won't employ vaccinated teachers",
    "5 million Americans have missed 2nd COVID-19 vaccine dose, CDC data shows",
    "European Union ready to allow vaccinated tourists from America to visit this summer",
    "Asia Today: India records 320K cases as foreign help arrives",
    "4 serious accusations facing Boris Johnson at the moment",
    "Indonesia says 53 Crew Members of Missing Submarine are Dead, Wreckage Found",
    "Crystal Palace's Zaha extends notable Premier League run against Leicester City",
    "The Debate - Erdogan's battles: Turkey's leader digs in against domestic rivals",
  ];

  int keywordIndex;
  String keyword;

  bool gameOver = false;
  int mistakeIndex = 0;
  final int maxMistakes = 7;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Shuffle the keywords list
    keywords.shuffle();

    //  Assign random keyword
    keywordIndex = 0;
    keyword = keywords[keywordIndex].toString().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 60.0, left: 20.0, right: 20.0, bottom: 40.0),
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Text('Remaining guesses: ${maxMistakes - mistakeIndex}'),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      height: 120,
                      width: 120,
                      child: Stack(
                        children: <Widget>[
                          mistakeIndex > 0 && mistakeIndex <= 7
                              ? Image.asset('images/doodle-1/wrong_0.png')
                              : Text(''),
                          mistakeIndex > 1 && mistakeIndex <= 7
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
                                      .bodyText1
                                      .copyWith(
                                        color: _wrongLetters.contains(char)
                                            ? Theme.of(context).accentColor
                                            : (_usedLetters.contains(char)
                                                ? Colors.grey
                                                : Theme.of(context)
                                                    .primaryColor),
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
        keywordCopy = keywordCopy.replaceAll(char, '_ ');
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
      // _resetMistakeIndex();
    }
  }

  void _increaseMistakeIndex() {
    mistakeIndex++;
  }

  void _setGameOver(bool b) {
    gameOver = b;
  }

  void _resetMistakeIndex() {
    mistakeIndex = 0;
  }

  _nextKeyword() {
    setState(() {
      mistakeIndex = 0;
      keywordIndex++;
      keyword = keywords[keywordIndex % keywords.length];
      _setGameOver(false);
    });
  }

  _getButton(String char, Text text, void Function() onPressed) =>
    _usedLetters.contains(char) ? OutlinedButton(
      onPressed: onPressed,
      child: text,
    ) : ElevatedButton(
      onPressed: onPressed,
      child: text,
    );

}

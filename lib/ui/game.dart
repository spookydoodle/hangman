import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hangman/model/headline_model.dart';
import 'package:hangman/network/network.dart';
import 'package:hangman/ui/home.dart';

class Range {
  final int min;
  final int max;

  Range(this.min, this.max);
}

class GameOverDisplayData {
  String message;
  String buttonText;
  Function onPressed;

  GameOverDisplayData({this.message, this.buttonText, this.onPressed});
}

class GameOverDisplay {
  GameOverDisplayData won;
  GameOverDisplayData lost;

  GameOverDisplay({this.won, this.lost});
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final List _alphabet = ['ABCDEFG', 'HIJKLMN', 'OPQRSTU', 'VWXYZ'];
  List _usedLetters = [];
  List _wrongLetters = [];

  final Range _maxMistakesRange = Range(3, 7);

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
  Future<List<HeadlineModel>> _data;

  // List keywords = [];
  List keywords = [];

  int page = 1;
  int keywordIndex = -1;
  String keyword;
  int maxMistakes;
  int wonGames = 0;
  int mistakeIndex = 0;
  bool gameOver = false;

  // Play to be set to false when insufficient keywords list (requires data fetch)
  bool isKeywordListOk = false;

  @override
  void initState() {
    super.initState();
    _data = HeadlineNetwork().getHeadlines(page: page);
    _nextGame();
  }

  @override
  Widget build(BuildContext context) {
    // print('NEW GAME ' + maxMistakes.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [ElevatedButton(onPressed: _onHome, child: Text('Home'))],
      ),
      body: Center(
          child: FutureBuilder<List<HeadlineModel>>(
        future: _data,
        builder: (BuildContext context,
                AsyncSnapshot<List<HeadlineModel>> snapshot) =>
            snapshot.hasData && isKeywordListOk
                ? gameView()
                : CircularProgressIndicator(),
      )),
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

  // Result check
  void _onCorrect() {
    if (_replaceChar() == keyword) {
      _setGameOver(true);
      print("You won");
      // TODO: Display message and then run _nextKeyword()
      _increaseWonGames();
      // _nextGame();
    }
  }

  bool isLost() {
    return mistakeIndex == maxMistakes;
  }

  // Increase index and if reached the max allowed mistakes end the game and reset index
  void _onMistake(String char) {
    if (!gameOver) {
      if (!_wrongLetters.contains(char)) {
        _wrongLetters.add(char);
        _increaseMistakeIndex();
      }
    }

    if (isLost()) {
      _setGameOver(true);
    }
  }

  void _increaseMistakeIndex() {
    mistakeIndex++;
  }

  void _resetMistakeIndex() {
    mistakeIndex = 0;
  }

  void _increaseWonGames() {
    wonGames++;
  }

  void _resetWonGames() {
    wonGames = 0;
  }

  void _setGameOver(bool b) {
    gameOver = b;
  }

  void _setIsKeywordListOk(bool b) {
    isKeywordListOk = b;
  }

  void _increaseKeywordIndex() {
    keywordIndex++;
  }

  void _resetKeywordIndex() {
    keywordIndex = 0;
  }

  bool isKeywordIndexOk() {
    return keywords.length > 0 && keywordIndex < keywords.length;
  }

  void _selectKeyword() {
    if (isKeywordIndexOk()) {
      keyword = keywords[keywordIndex].toString().toUpperCase();

      return;
    }

    // If for some reason select is not possible; run next game to update keywords;
    _nextGame();
  }

  void _resetAlphabet() {
    _usedLetters = [];
    _wrongLetters = [];
  }

  // Adjust maxMistakes based on number of unique characters in the headline
  void _setMaxMistakes(int min, int max, int factor) {
    final String alphabetStr = _alphabet.join('');
    final int alphabetLen = alphabetStr.length;

    int uniqueCharLen = keyword
        .replaceAll(' ', '')
        .split('')
        .toSet()
        .toList()
        .where((char) => alphabetStr.contains(char.toUpperCase()))
        .length;

    int maxUniqueN = alphabetLen - (min * factor);
    int minUniqueN = alphabetLen - (max * factor);

    if (uniqueCharLen > maxUniqueN) {
      _nextGame();
      return;
    }

    maxMistakes = uniqueCharLen < minUniqueN
        ? max
        : ((alphabetLen - uniqueCharLen) / factor).floor();
  }

  void _updateKeywords() {
    setState(() {
      _data.then((headlines) {
        keywords = headlines.map((e) => e.headline).toList();
        _setIsKeywordListOk(true);
        _nextGame();
      });
    });
  }

  // Game state
  void _nextGame({bool reset = false}) {
    if (isKeywordListOk && !isKeywordIndexOk()) {
      setState(() {
        _setIsKeywordListOk(false);
      });
    }

    // Fetch new data and prevent from continuing.
    // The fetch method runs _nextGame() again once data is updated
    if (!isKeywordListOk) {
      _updateKeywords();
      return;
    }

    // Set next game state, if data does not need to be updated yet
    _setNextGameState(reset: reset);
  }

  void _setNextGameState({bool reset = false}) {
    setState(() {
      _resetAlphabet();
      _increaseKeywordIndex();
      _selectKeyword();
      _resetMistakeIndex();
      _setMaxMistakes(_maxMistakesRange.min, _maxMistakesRange.max, 2);
      _setGameOver(false);

      if (reset) {
        _resetWonGames();
      }
    });
  }

  // User Interface components
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

  Widget gameView() {
    GameOverDisplay gameOverDisplay = GameOverDisplay(
      won: GameOverDisplayData(
          message: 'You Won! ;-)',
          buttonText: 'Next Game',
          onPressed: () => _nextGame(reset: false)),
      lost: GameOverDisplayData(
          message: 'You Lost! ;-(',
          buttonText: 'Start New Game',
          onPressed: () => _nextGame(reset: true)),
    );

    GameOverDisplayData gameOverDisplayData =
        isLost() ? gameOverDisplay.lost : gameOverDisplay.won;

    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, left: 20.0, right: 20.0, bottom: 40.0),
      child: Stack(
        children: [
          Column(
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
                          mistakeIndex > 0 && mistakeIndex <= maxMistakes
                              ? mistakeImages[0]
                              : Text(''),
                          mistakeIndex > 1 && mistakeIndex <= maxMistakes
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
          gameOver
              ? Center(
                  child: Column(children: [
                    Spacer(),
                    Container(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                gameOverDisplayData.message,
                                style: TextStyle(color: Colors.white),
                              ),
                              ElevatedButton(
                                  onPressed: gameOverDisplayData.onPressed,
                                  child: Text(gameOverDisplayData.buttonText))
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                        color: Colors.black),
                  ]),
                )
              // TODO: handle display only if game over
              : Text('')
        ],
      ),
    );
  }

  // TODO: Make a generic util function
  _onHome() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home()));
  }
}

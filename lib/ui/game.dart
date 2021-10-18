import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hangman/model/headline_model.dart';
import 'package:hangman/network/network.dart';
import 'package:hangman/settings/memory.dart';
import 'package:hangman/settings/settings.dart';
import 'package:hangman/settings/storage.dart';
import 'package:hangman/ui/home.dart';

// TODO:
// CustomScrollView(
//   slivers: <Widget>SliverAppBar(
//     title: Text('Sliver App Bar'),
//     expandedHeight: 200.0
//     flexibleSpace: FlexibleSpaceBar(
//       background: _image,
//     ),
//      floating: true
//   )
// )
class Range {
  final int min;
  final int max;

  Range(this.min, this.max);
}

class GameOverDisplayData {
  final String message;
  final String buttonText;
  final void Function() onPressed;

  const GameOverDisplayData(
      {required this.message,
      required this.buttonText,
      required this.onPressed});
}

class GameOverDisplay {
  final GameOverDisplayData won;
  final GameOverDisplayData lost;

  GameOverDisplay({required this.won, required this.lost});
}

class Game extends StatefulWidget {
  const Game({Key? key, required this.storage}) : super(key: key);

  // const Game({Key? key, required this.storage}) : super(key: key);

  final FileManager storage;

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
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
  Future<List<HeadlineModel>> _data =
      HeadlineNetwork().getHeadlines();

  // List keywords = [];
  List<HeadlineModel> keywords = [];

  int page = 1;
  int keywordIndex = -1;
  String keyword = "";
  String replacedKeyword = "";
  int maxMistakes = 7;
  int wonGames = 0;
  int mistakeIndex = 0;
  bool play = true;
  bool gameOver = false;
  bool isKeywordListOk = false;

  @override
  void initState() {
    super.initState();
    _data = HeadlineNetwork().getHeadlines();
    _nextGame();

    // TODO: Move to appropriate method
    widget.storage.readHeadlineIds().then((String value) {
      print('Value is: ');
      value.split(';').toSet().toList().where((headlineId) => headlineId != '').forEach((headlineId) {
        print(headlineId);
        Memory.processedIds.add(int.tryParse(headlineId) ?? 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _onHome,
            color: Theme.of(context).accentColor,
            splashRadius: 20.0,
          ),
          Spacer(),
          Hero(
            tag: 'hero-avatar',
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset('images/doodle-1/main.png'),
              ),
            ),
          ),
        ],
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
    _alphabet.split('').forEach((char) {
      if (!_usedLetters.contains(char)) {
        keywordCopy =
            gameOver ? keywordCopy : keywordCopy.replaceAll(char, '_');
      }
    });

    return keywordCopy;
  }

  void _checkLetter(String char) {
    setState(() {
      _usedLetters.add(char);

      if (keyword.contains(char)) {
        _onCorrect();
      } else {
        _onMistake(char);
      }
    });
  }

  // Result check
  void _onCorrect() {
    replacedKeyword = _replaceChar();

    if (replacedKeyword == keyword) {
      _setPlay(false);
      _increaseWonGames();
    }
  }

  // Increase index and if reached the max allowed mistakes end the game and reset index
  void _onMistake(String char) {
    if (!_wrongLetters.contains(char)) {
      _wrongLetters.add(char);
      _increaseMistakeIndex();
      _setGameOver(mistakeIndex == maxMistakes);
    }

    if (gameOver) {
      _setPlay(false);
    }
  }

  void _setGameOver(bool b) {
    gameOver = b;
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

  void _setPlay(bool b) {
    play = b;
  }

  void _setIsKeywordListOk(bool b) {
    isKeywordListOk = b;
  }

  void _increaseKeywordIndex() {
    keywordIndex++;
  }

  void _increasePageIndex() {
    Settings.page++;
  }

  void _resetKeywordIndex() {
    keywordIndex = 0;
  }

  bool isKeywordIndexOk() {
    return keywords.length > 0 && keywordIndex < keywords.length;
  }

  void _selectKeyword() {
    if (isKeywordIndexOk()) {
      HeadlineModel headline = keywords[keywordIndex];
      keyword = headline.headline.toString().toUpperCase();
      Memory.processedIds.add(headline.id);
      widget.storage.writeHeadline(headline.id.toString());

      if (keyword.length > 65) {
        print('SKIPPED');
        print(keyword);
        _nextGame();
      }

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
    final String alphabetStr = _alphabet;
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
        _increasePageIndex();

        keywords = headlines
            .where((headline) => !Memory.processedIds.contains(headline.id))
            .toList();

        // TODO: replace with a method returning if keyword list is ok
        _setIsKeywordListOk(true);
        _resetKeywordIndex();

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
      _setPlay(true);

      if (reset) {
        _setGameOver(false);
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
        gameOver ? gameOverDisplay.lost : gameOverDisplay.won;

    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, left: 20.0, right: 20.0, bottom: 40.0),
      child: Stack(
        children: [
          // TODO: On overflow scroll
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
              // TODO: Consider Table widget
              Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                children: <Widget>[
                  ..._alphabet.split('').map((char) => _getButton(
                      char,
                      Text(
                        char.toString().toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(
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
                          () => _checkLetter(char)
                  ))
                ],
              ),
            ],
          ),
          if (!play)
            Center(
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
            ),
        ],
      ),
    );
  }

  _onHome() {
    Navigator.pop(context);
  }
}

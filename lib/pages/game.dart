import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:hangman/files/storage.dart';
import 'package:hangman/model/common.dart';
import 'package:hangman/model/headline.dart';
import 'package:hangman/network/network.dart';
import 'package:hangman/settings/memory.dart';
import 'package:hangman/settings/settings.dart';
import 'package:hangman/components/game.dart';

// Storage is used to save processed headline ID's in order not to display the same headline more than once
class Game extends StatefulWidget {
  const Game({Key? key, required this.storage}) : super(key: key);

  final FileManager storage;

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<String> _alphabet = [];
  List<String> _usedLetters = [];
  List<String> _wrongLetters = [];

  bool _gameOver = false;
  bool _gameWon = false;

  int _page = 1;
  Future<List<HeadlineModel>> _data = HeadlineNetwork().getHeadlines(1);

  List<HeadlineModel> _keywords = [];
  int _keywordIndex = 0;
  String _keyword = "";
  String _replacedKeyword = "";
  final int _maxKeywordLength = 65;

  final Range _maxMistakesRange = Range(3, 7);
  int _maxMistakes = 7;
  int mistakeIndex = 0;
  int wonGames = 0;

  String _error = '';

  @override
  void initState() {
    super.initState();
    _copyProcessedIdsToMemory();
    _alphabet = getAlphabet(Settings.country)
        .split('')
        .map((char) => char.toUpperCase())
        .toList();

    _nextGame(reset: true);
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
            AsyncSnapshot<List<HeadlineModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error while fetching data');
            } else if (_error != '') {
              return Text(_error);
            }

            if (snapshot.hasData && !_needsKeywordUpdate()) {
              return gameView(
                context: context,
                wonGames: wonGames,
                maxMistakes: _maxMistakes,
                mistakeIndex: mistakeIndex,
                keywordDisplay: _replaceChar(),
                alphabet: _alphabet,
                wrongLetters: _wrongLetters,
                usedLetters: _usedLetters,
                onLetterClick: _checkLetter,
                gameOver: _gameOver,
                gameWon: _gameWon,
                next: _nextGame,
              );
            } else {
              return Text('Could not find data or needs keywords list update.');
            }
          }

          return CircularProgressIndicator();
        },
      )),
    );
  }

  void _copyProcessedIdsToMemory() {
    widget.storage.readHeadlineIds().then((String value) {
      value
          .split(';')
          .toSet()
          .toList()
          .where((headlineId) => headlineId != '')
          .forEach((headlineId) {
        Memory.processedIds.add(int.tryParse(headlineId) ?? 1);
      });
    });
  }

  bool _needsKeywordUpdate() {
    var len = _keywords.length;
    return len == 0 || _keywordIndex >= len;
  }

  String _replaceChar() {
    var keywordCopy = [..._keyword.split('')].join('').toUpperCase();
    _alphabet.forEach((char) {
      if (!_usedLetters.contains(char)) {
        keywordCopy =
            _gameOver ? keywordCopy : keywordCopy.replaceAll(char, '_');
      }
    });

    return keywordCopy;
  }

  void _checkLetter(String char) {
    if (!_gameOver && !_gameWon) {
      setState(() {
        _usedLetters.add(char);

        if (_keyword.contains(char)) {
          _onCorrect();
        } else {
          _onMistake(char);
        }
      });
    }
  }

  // Result check
  void _onCorrect() {
    _replacedKeyword = _replaceChar();

    if (_replacedKeyword == _keyword) {
      _setGameWon(true);
      _increaseWonGames();
    }
  }

  // Increase index and if reached the max allowed mistakes end the game and reset index
  void _onMistake(String char) {
    if (!_wrongLetters.contains(char)) {
      _wrongLetters.add(char);
      _increaseMistakeIndex();
      _setGameOver(mistakeIndex == _maxMistakes);
    }
  }

  void _setGameOver(bool b) {
    _gameOver = b;
  }

  void _increaseMistakeIndex() {
    mistakeIndex++;
  }

  void _resetMistakeIndex() {
    mistakeIndex = 0;
  }

  void _setGameWon(bool b) {
    _gameWon = b;
  }

  void _increaseWonGames() {
    wonGames++;
  }

  void _resetWonGames() {
    wonGames = 0;
  }

  void _increaseKeywordIndex() {
    _keywordIndex++;
  }

  void _increaseKeywordIndexState() {
    setState(() {
      _increaseKeywordIndex();
    });
  }

  void _increasePageIndex() {
    _page++;
  }

  void _resetKeywordIndex() {
    _keywordIndex = 0;
  }

  void _setKeywords(List<HeadlineModel> newKeywords) {
    _keywords = newKeywords;
  }

  String _selectKeyword(void Function() onDone) {
    HeadlineModel headline = _keywords[_keywordIndex];
    Memory.processedIds.add(headline.id);
    widget.storage.writeHeadline(headline.id.toString());

    onDone();

    return headline.headline.toString().toUpperCase();
  }

  void _setKeyword(String newKeyword) {
    _keyword = newKeyword;
  }

  void _resetAlphabet() {
    _usedLetters = [];
    _wrongLetters = [];
  }

  // Adjust maxMistakes based on number of unique characters in the headline. Returns -1 for rejected keywords
  int _getMaxMistakes(String text) {
    final int factor = 2;
    final int min = _maxMistakesRange.min;
    final int max = _maxMistakesRange.max;
    final int alphabetLen = _alphabet.length;

    int uniqueCharLen = text
        .replaceAll(' ', '')
        .split('')
        .toSet()
        .toList()
        .where((char) => _alphabet.contains(char.toUpperCase()))
        .length;

    int maxUniqueN = alphabetLen - (min * factor);
    int minUniqueN = alphabetLen - (max * factor);

    if (uniqueCharLen > maxUniqueN) {
      return -1;
    }

    return uniqueCharLen < minUniqueN
        ? max
        : ((alphabetLen - uniqueCharLen) / factor).floor();
  }

  void _setMaxMistakes(int n) {
    _maxMistakes = n;
  }

  // Scenario 1: API page returns 0 results - Try to fetch results 5 times for ++page, if nothing received show error and go back to home screen
  // Scenario 2: API page returns results but processing returns 0 suitable results, page++ and repeat until success (unless scenario 1)
  void _updateKeywords(void Function() onDone) async {
    int maxRetry = 5;

    for (int retry = 0; retry < maxRetry; retry++) {
      var headlines = await HeadlineNetwork().getHeadlines(_page);

      setState(() {
        _increasePageIndex();
      });

      if (headlines.length == 0) {
        // If data is unavailable after max-retry times, display appropriate error
        if (retry == maxRetry - 1) {
          setState(() {
            _error =
                'You\'ve read all the news in the world! Choose another category or come back tomorrow!';
          });
        }

        continue;
      }

      var newKeywords = headlines
          .where((headline) => !Memory.processedIds.contains(headline.id))
          .toList();

      if (newKeywords.length == 0) {
        retry = 0;
        continue;
      }

      if (newKeywords.length > 0) {
        setState(() {
          _resetKeywordIndex();
          _setKeywords(newKeywords);
        });

        onDone();
        break;
      }
    }
  }

  bool _needKeywordUpdate() =>
      _keywords.length == 0 || _keywordIndex >= _keywords.length;

  // Main game
  void _nextGame({bool reset = false}) {
    // Fetch new data, then run next game. Prevent this method from continuing
    if (_needKeywordUpdate()) {
      _updateKeywords(() => _nextGame(reset: reset));
      return;
    }

    // Select new keyword and determine maxMistakes
    String newKeyword = _selectKeyword(_increaseKeywordIndexState);
    int newMaxMistakes = _getMaxMistakes(newKeyword);

    // If keyword too long to display or if number of unique characters too large compared to alphabet length -> skip this game and run next
    if (newKeyword.length > _maxKeywordLength || newMaxMistakes == -1) {
      _nextGame(reset: reset);
      return;
    }

    // Set state to launch game
    setState(() {
      _resetAlphabet();
      _resetMistakeIndex();
      _setKeyword(newKeyword);
      _setMaxMistakes(newMaxMistakes);
      _setGameWon(false);

      if (reset) {
        _setGameOver(false);
        _resetWonGames();
      }
    });
  }

  _onHome() {
    Navigator.pop(context);
  }
}

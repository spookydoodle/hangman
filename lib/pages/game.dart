import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:hangman/files/storage.dart';
import 'package:hangman/model/common.dart';
import 'package:hangman/model/headline.dart';
import 'package:hangman/network/network.dart';
import 'package:hangman/settings/memory.dart';
import 'package:hangman/settings/settings.dart';
import 'package:hangman/ui/game.dart';

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

  final Range _maxMistakesRange = Range(3, 7);

  Future<List<HeadlineModel>> _data = HeadlineNetwork().getHeadlines();

  // List keywords = [];
  List<HeadlineModel> keywords = [];

  int keywordIndex = -1;
  String keyword = "";
  String replacedKeyword = "";
  int maxMistakes = 7;
  int wonGames = 0;
  int mistakeIndex = 0;
  bool gameOver = false;
  bool gameWon = false;

  int fetchAttempt = 0;

  @override
  void initState() {
    super.initState();
    Settings.page = 1;
    _copyProcessedIdsToMemory();
    _alphabet = getAlphabet(Settings.country)
        .split('')
        .map((char) => char.toUpperCase())
        .toList();
    _nextGame();
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
            }

            if (snapshot.hasData && !_needsKeywordUpdate()) {
              return gameView(
                context: context,
                wonGames: wonGames,
                maxMistakes: maxMistakes,
                mistakeIndex: mistakeIndex,
                keywordDisplay: _replaceChar(),
                alphabet: _alphabet,
                wrongLetters: _wrongLetters,
                usedLetters: _usedLetters,
                onLetterClick: _checkLetter,
                gameOver: gameOver,
                gameWon: gameWon,
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
    var len = keywords.length;
    return len == 0 || keywordIndex >= len;
  }

  String _replaceChar() {
    var keywordCopy = [...keyword.split('')].join('').toUpperCase();
    _alphabet.forEach((char) {
      if (!_usedLetters.contains(char)) {
        keywordCopy =
            gameOver ? keywordCopy : keywordCopy.replaceAll(char, '_');
      }
    });

    return keywordCopy;
  }

  void _checkLetter(String char) {
    if (!gameOver && !gameWon) {
      setState(() {
        _usedLetters.add(char);

        if (keyword.contains(char)) {
          _onCorrect();
        } else {
          _onMistake(char);
        }
      });
    }
  }

  // Result check
  void _onCorrect() {
    replacedKeyword = _replaceChar();

    if (replacedKeyword == keyword) {
      _setGameWon(true);
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

  void _setGameWon(bool b) {
    gameWon = b;
  }

  void _increaseWonGames() {
    wonGames++;
  }

  void _resetWonGames() {
    wonGames = 0;
  }

  void _increaseKeywordIndex() {
    keywordIndex++;
  }

  void _increasePageIndex() {
    Settings.page++;
  }

  void _resetKeywordIndex() {
    keywordIndex = -1;
  }

  void _setKeywords(List<HeadlineModel> newKeywords) {
    keywords = newKeywords;
  }

  void _selectKeyword() {
    if (!_needsKeywordUpdate()) {
      HeadlineModel headline = keywords[keywordIndex];
      keyword = headline.headline.toString().toUpperCase();
      Memory.processedIds.add(headline.id);
      widget.storage.writeHeadline(headline.id.toString());

      if (keyword.length > 65) {
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
    final int alphabetLen = _alphabet.length;

    int uniqueCharLen = keyword
        .replaceAll(' ', '')
        .split('')
        .toSet()
        .toList()
        .where((char) => _alphabet.contains(char.toUpperCase()))
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
    print('UPDATING KEYWORDS');
    print('FETCH ATTEMPT NR:');
    print(fetchAttempt);
    if (fetchAttempt < 3) {
      _data.then((headlines) {
        var newKeywords = headlines
            .where((headline) => !Memory.processedIds.contains(headline.id))
            .toList();

        print('NEW KEYWORDS LEN:');
        print(newKeywords.length);
        setState(() {
          if (newKeywords.length > 0) {
            fetchAttempt = 0;
          } else {
            fetchAttempt++;
          }

          _increasePageIndex();
          _resetKeywordIndex();
          _setKeywords(newKeywords);
        });

        _nextGame();
      }).catchError((err) {
        print('FETCH ERROR');
        print(err);
      });
    } else {
      print('FETCH LIMIT EXCEEDED');
    }
  }

  // Game state - increase index -> check if list needs to update -> run new game
  void _nextGame({bool reset = false}) {
    print('NEW GAME');
    setState(() {
      print('NEW GAME - Increase Keyword Index');
      print(keywordIndex);

      _increaseKeywordIndex();

      print(keywordIndex);
      print('KEYWORD INDEX INCREASED');
    });

    // Fetch new data and prevent from continuing.
    // The fetch method runs _nextGame() again once data is updated
    if (keywords.length == 0 || keywordIndex >= keywords.length) {
      print('NEEDS KEYWORD UPDATE');
      print(keywords.length);
      print(keywordIndex);
      _updateKeywords();

      return;
    }

    // Set next game state, if data does not need to be updated yet
    print('SETTING NEXT GAME STATE');
    _setNextGameState(reset: reset);
  }

  void _setNextGameState({bool reset = false}) {
    if (!_needsKeywordUpdate()) {
      setState(() {
        _resetAlphabet();
        _selectKeyword();
        _resetMistakeIndex();
        _setMaxMistakes(_maxMistakesRange.min, _maxMistakesRange.max, 2);
        _setGameWon(false);

        if (reset) {
          _setGameOver(false);
          _resetWonGames();
        }
      });
    }
  }

  _onHome() {
    Navigator.pop(context);
  }
}

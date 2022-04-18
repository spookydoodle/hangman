import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hangman/files/storage.dart';
import 'package:hangman/model/common.dart';
import 'package:hangman/model/headline.dart';
import 'package:hangman/network/network.dart';
import 'package:hangman/settings/memory.dart';
import 'package:hangman/settings/settings.dart';
import 'package:hangman/settings/translator.dart';
import 'package:hangman/widgets/game/game.dart';
import 'package:hangman/widgets/game/game_app_bar.dart';
import 'package:hangman/widgets/navigation/error_popup.dart';

class Game extends StatefulWidget {
  final FileManager storage;
  final Translator translator;
  final Country country;
  final Category category;

  const Game(
      {Key? key,
      required this.storage,
      required this.translator,
      required this.country,
      required this.category})
      : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final HeadlineNetwork _network = HeadlineNetwork();
  int _networkPage = 1;

  List<String> _alphabet = [];
  List<String> _usedLetters = [];
  List<String> _wrongLetters = [];

  bool _isGameInProgress = true;
  bool _gameWon = false;

  List<Keyword> _keywords = [];
  int _keywordIndex = -1;
  Keyword _keyword = new Keyword(id: -1, text: "", url: "", maxMistakes: -1);
  String _replacedKeyword = "";
  final int _maxKeywordLength = 65;

  final Range _maxMistakesRange = Range(3, 7);
  int _mistakeIndex = 0;
  int _wonGames = 0;

  String _error = '';

  @override
  void initState() {
    super.initState();

    _copyProcessedIdsToMemory();

    _alphabet = Settings.getAlphabet(widget.country)
        .split('')
        .map((char) => char.toUpperCase())
        .toList();

    _nextGame(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gameAppBar(context, _onHome),
      body: Center(child: _body()),
    );
  }

  Widget _body() {
    if (_isError()) {
      return errorPopup(_error, _onHome);
    }

    return _needsKeywordsUpdate()
        ? CircularProgressIndicator()
        : gameView(
            context: context,
            translator: widget.translator,
            wonGames: _wonGames,
            maxMistakes: _keyword.maxMistakes,
            mistakeIndex: _mistakeIndex,
            keyword: _keyword.text,
            url: _keyword.url,
            alphabet: _alphabet,
            wrongLetters: _wrongLetters,
            usedLetters: _usedLetters,
            onLetterClick: _checkLetter,
            isGameInProgress: _isGameInProgress,
            gameWon: _gameWon,
            next: _nextGame,
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

  String _replaceChar() {
    String keywordCopy = [..._keyword.text.split('')].join('').toUpperCase();

    _alphabet.forEach((char) {
      if (!_usedLetters.contains(char)) {
        keywordCopy =
            _isGameInProgress ? keywordCopy.replaceAll(char, '_') : keywordCopy;
      }
    });

    return keywordCopy;
  }

  void _checkLetter(String char) {
    if (_isGameInProgress && !_gameWon) {
      var isCharInKeyword =
          _keyword.text.toUpperCase().contains(char.toUpperCase());

      setState(() {
        _usedLetters.add(char);

        if (isCharInKeyword) {
          _onCorrect();
        } else {
          _onMistake(char);
        }
      });
    }
  }

  void _onCorrect() {
    _replacedKeyword = _replaceChar();
    var gameWon = _replacedKeyword == _keyword.text;
    _setIsGameInProgress(!gameWon);

    if (gameWon) {
      _setGameWon(true);
      _increaseWonGames();
    }
  }

  void _onMistake(String char) {
    if (!_wrongLetters.contains(char)) {
      _wrongLetters.add(char);
      _increaseMistakeIndex();
      _setIsGameInProgress(_mistakeIndex < _keyword.maxMistakes);
    }
  }

  void _increaseMistakeIndex() {
    _mistakeIndex++;
  }

  void _increaseWonGames() {
    _wonGames++;
  }

  // Main game
  void _nextGame({required bool reset}) async {
    if (_isError()) {
      return;
    }

    _increaseKeywordIndex();

    // Fetch new data, then run next game. Prevent this method from continuing
    if (_needsKeywordsUpdate()) {
      if (!await _checkInternetConnection()) {
        // TODO: Save current user's score
        setState(() {
          _setError("It looks like you're not connected to the internet. Connect and try again.");
        });

        return;
      }

      await _updateKeywords();
      _nextGame(reset: reset);

      return;
    }

    _launchGame(reset: reset, keyword: _getKeyword());
  }

  bool _needsKeywordsUpdate() {
    var len = _keywords.length;
    return len == 0 || _keywordIndex >= len;
  }

  Future<bool> _checkInternetConnection() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      var isConnected = connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile;

      return isConnected;
    } catch (err) {
      return false;
    }
  }

  Future<void> _updateKeywords() async {
    var keywords = await _getNewKeywords();

    setState(() {
      _resetKeywordIndex();
      _setKeywords(keywords);
    });
  }

  // Scenario 1: API page returns 0 results - Try to fetch results 5 times for ++page, if nothing received show error and go back to home screen
  // Scenario 2: API page returns results but processing returns 0 suitable results, page++ and repeat until success (unless scenario 1)
  Future<List<Keyword>> _getNewKeywords() async {
    int maxRetry = 5;
    List<Keyword> newKeywords = [];

    for (int retry = 1; retry < maxRetry; retry++) {
      var headlines = await _fetchHeadlines(_networkPage);
      _increaseNetworkPageIndex();

      if (headlines.length == 0) {
        if (retry == maxRetry) {
          setState(() {
            _setError(
                'You\'ve read all the news in the world! Choose another category or come back tomorrow!');
          });
        }

        continue;
      }

      newKeywords = headlines
          .where((headline) => _isHeadlineOk(headline.id, headline.headline,
              _getMaxMistakes(headline.headline)))
          .map((headline) => new Keyword(
              id: headline.id,
              text: headline.headline.replaceAll(RegExp(' +'), ' ').toUpperCase(),
              url: headline.url,
              maxMistakes: _getMaxMistakes(headline.headline)))
          .toList();

      if (newKeywords.length == 0) {
        continue;
      }

      break;
    }

    return newKeywords;
  }

  Future<List<HeadlineModel>> _fetchHeadlines(int page) async {
    try {
      var headlines =
          await _network.getHeadlines(widget.category, widget.country, page);

      return headlines;
    } catch (err) {
      setState(() {
        _setError(err.toString().contains('TimeoutException') ? "It's taking too long... Check your internet connection.": err.toString());
      });

      return [];
    }
  }

  void _resetKeywordIndex() {
    _keywordIndex = -1;
  }

  void _setKeywords(List<Keyword> newKeywords) {
    _keywords = newKeywords;
  }

  void _increaseNetworkPageIndex() {
    _networkPage++;
  }

  _isHeadlineOk(int id, String text, int maxMistakes) {
    return !_isHeadlineProcessed(id) &&
        !_isKeywordTooLong(text) &&
        !_isMaxMistakesOutOfRange(maxMistakes);
  }

  _isHeadlineProcessed(int id) {
    return Memory.processedIds.contains(id);
  }

  _isKeywordTooLong(String text) {
    return text.length > _maxKeywordLength;
  }

  _isMaxMistakesOutOfRange(maxMistakes) {
    return maxMistakes == -1;
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

  Keyword _getKeyword() {
    Keyword keyword = _keywords[_keywordIndex];

    Memory.processedIds.add(keyword.id);
    widget.storage.writeHeadline(keyword.id.toString());

    return keyword;
  }

  _launchGame({required bool reset, required Keyword keyword}) {
    setState(() {
      _resetAlphabet();
      _resetMistakeIndex();
      _setKeyword(keyword);
      _setGameWon(false);
      _setIsGameInProgress(true);

      if (reset) {
        _resetWonGames();
      }
    });
  }

  void _increaseKeywordIndex() {
    _keywordIndex++;
  }

  void _resetAlphabet() {
    _usedLetters = [];
    _wrongLetters = [];
  }

  void _resetMistakeIndex() {
    _mistakeIndex = 0;
  }

  void _setKeyword(Keyword keyword) {
    _keyword = keyword;
  }

  void _setGameWon(bool b) {
    _gameWon = b;
  }

  void _setIsGameInProgress(bool b) {
    _isGameInProgress = b;
  }

  void _resetWonGames() {
    _wonGames = 0;
  }

  void _setError(String error) {
    _error = error;
  }

  bool _isError() {
    return _error != '';
  }

  _onHome() {
    Navigator.pop(context);
  }
}

import 'package:flutter/material.dart';
import 'package:hangman/settings/translator.dart';
import 'package:hangman/widgets/game/game_over_popup.dart';
import 'package:hangman/widgets/game/keyboard.dart';
import 'package:hangman/widgets/game/keyword_display.dart';
import 'package:hangman/widgets/game/score.dart';

Widget gameView({
  required BuildContext context,
  required Translator translator,
  required int wonGames,
  required int maxMistakes,
  required int mistakeIndex,
  required String keyword,
  required String url,
  required List<String> alphabet,
  required List<String> wrongLetters,
  required List<String> usedLetters,
  required void Function(String) onLetterClick,
  required bool isGameInProgress,
  required bool gameWon,
  required void Function({required bool reset}) next,
}) {
  return Padding(
    padding:
        const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 40.0),
    child: Stack(
      children: [
        // TODO: Handle overflow (scroll?)
        _game(
            context: context,
            translator: translator,
            wonGames: wonGames,
            maxMistakes: maxMistakes,
            mistakeIndex: mistakeIndex,
            keyword: keyword,
            alphabet: alphabet,
            wrongLetters: wrongLetters,
            usedLetters: usedLetters,
            onLetterClick: onLetterClick,
            isGameLost: !isGameInProgress && !gameWon),
        if (!isGameInProgress)
          gameWon
              ? gameOverPopup(
                  translator: translator,
                  message: translator.youWon,
                  buttonText: translator.nextGame,
                  url: url,
                  onPressed: () => next(reset: false))
              : gameOverPopup(
                  translator: translator,
                  message: translator.youLost,
                  buttonText: translator.startNewGame,
                  url: url,
                  onPressed: () => next(reset: true)),
      ],
    ),
  );
}

Widget _game(
    {required BuildContext context,
    required Translator translator,
    required int wonGames,
    required int maxMistakes,
    required int mistakeIndex,
    required String keyword,
    required List<String> alphabet,
    required List<String> usedLetters,
    required List<String> wrongLetters,
    required void Function(String) onLetterClick,
    required bool isGameLost}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      score(
          translator: translator,
          wonGames: wonGames,
          mistakeIndex: mistakeIndex,
          maxMistakes: maxMistakes),
      // Spacer(),
      keywordDisplay(
          context: context,
          keyword: keyword,
          usedLetters: usedLetters,
          alphabet: alphabet,
          isGameLost: isGameLost),
      // Spacer(),
      keyboard(
          context: context,
          alphabet: alphabet,
          usedLetters: usedLetters,
          wrongLetters: wrongLetters,
          onLetterClick: onLetterClick),
    ],
  );
}

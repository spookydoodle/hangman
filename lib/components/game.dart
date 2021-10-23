import 'package:flutter/material.dart';

// User Interface components
//_usedLetters.contains(char)
Widget letterButton(
        {required void Function() onPressed,
        required Widget child,
        required bool used}) =>
    used
        ? OutlinedButton(onPressed: onPressed, child: child)
        : ElevatedButton(onPressed: onPressed, child: child);

Widget gameView({
  required BuildContext context,
  required int wonGames,
  required int maxMistakes,
  required int mistakeIndex,
  required String keywordDisplay,
  required List<String> alphabet,
  required List<String> wrongLetters,
  required List<String> usedLetters,
  required void Function(String) onLetterClick,
  required bool gameOver,
  required bool gameWon,
  required void Function({bool reset}) next,
}) {
  return Padding(
    padding:
        const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 40.0),
    child: Stack(
      children: [
        // TODO: Handle overflow (scroll?)
        mainGame(
          context: context,
          wonGames: wonGames,
          maxMistakes: maxMistakes,
          mistakeIndex: mistakeIndex,
          keywordDisplay: keywordDisplay,
          alphabet: alphabet,
          wrongLetters: wrongLetters,
          usedLetters: usedLetters,
          onLetterClick: onLetterClick
        ),
        if (gameWon)
          gameOverScreen(
              message: 'You Won! ;-)',
              buttonText: 'Next Game',
              onPressed: () => next(reset: false)),
        if (gameOver)
          gameOverScreen(
              message: 'You Lost! ;-(',
              buttonText: 'Start New Game',
              onPressed: () => next(reset: true)),
      ],
    ),
  );
}

Widget mainGame(
    {required BuildContext context,
    required int wonGames,
    required int maxMistakes,
    required int mistakeIndex,
    required String keywordDisplay,
    required List<String> alphabet,
    required List<String> usedLetters,
    required List<String> wrongLetters,
    required void Function(String) onLetterClick}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      displayScore(
          wonGames: wonGames,
          mistakeIndex: mistakeIndex,
          maxMistakes: maxMistakes),
      // Spacer(),
      displayKeyword(context: context, keywordDisplay: keywordDisplay),
      // Spacer(),
      displayAlphabet(
          context: context,
          alphabet: alphabet,
          usedLetters: usedLetters,
          wrongLetters: wrongLetters,
          onLetterClick: onLetterClick),
    ],
  );
}

// TODO: Replace with new graphics and handle dynamic maxMistakes
Widget displayScore(
    {required int wonGames,
    required int maxMistakes,
    required int mistakeIndex}) {
  final Image gallowsImage = Image.asset('images/doodle-1/wrong_0.png');
  final List mistakeImages = [
    Image.asset('images/doodle-1/wrong_1.png'),
    Image.asset('images/doodle-1/wrong_2.png'),
    Image.asset('images/doodle-1/wrong_3.png'),
    Image.asset('images/doodle-1/wrong_4.png'),
    Image.asset('images/doodle-1/wrong_5.png'),
    Image.asset('images/doodle-1/wrong_6.png'),
  ];

  return Column(
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
              if (mistakeIndex > 0 && mistakeIndex <= maxMistakes) gallowsImage,
              // Temp: gallows image
              if (mistakeIndex > 1 && mistakeIndex <= maxMistakes)
                mistakeImages[(mistakeIndex - 2) % mistakeImages.length],
              // Temp: character state
            ],
          ),
        ),
      ),
    ],
  );
}

// TODO: Move logic to cover characters from game to here
Widget displayKeyword(
    {required BuildContext context, required String keywordDisplay}) {
  return Text(keywordDisplay,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subtitle1);
}

// TODO: Consider Table widget
Widget displayAlphabet(
    {required BuildContext context,
    required List<String> alphabet,
    required List<String> usedLetters,
    required List<String> wrongLetters,
    required void Function(String) onLetterClick}) {
  return Wrap(
    alignment: WrapAlignment.center,
    direction: Axis.horizontal,
    children: <Widget>[
      ...alphabet.map((char) {
        bool wrong = wrongLetters.contains(char);
        bool used = usedLetters.contains(char);
        ThemeData theme = Theme.of(context);
        void Function() onPressed = () => onLetterClick(char);

        return letterButton(
            used: used,
            child: Text(
              char,
              style: theme.textTheme.button?.copyWith(
                color: wrong
                    ? theme.accentColor
                    : used
                        ? Colors.grey
                        : null,
                decoration:
                    used ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            onPressed: onPressed);
      })
    ],
  );
}

Widget gameOverScreen(
    {required String message,
    required String buttonText,
    required void Function() onPressed}) {
  return Center(
    child: Column(children: [
      Spacer(),
      Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(message, style: TextStyle(color: Colors.white)),
                ElevatedButton(onPressed: onPressed, child: Text(buttonText))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          color: Colors.black),
    ]),
  );
}

// TODO: Replace with new graphics and handle dynamic maxMistakes
import 'package:flutter/material.dart';
import 'package:hangman/settings/translator.dart';

Widget score(
    {required Translator translator,
    required int wonGames,
    required int maxMistakes,
    required int mistakeIndex}) {
  final Image gallowsImage = Image.asset('assets/images/doodle-1/wrong_0.png');
  final List mistakeImages = [
    Image.asset('assets/images/doodle-1/wrong_1.png'),
    Image.asset('assets/images/doodle-1/wrong_2.png'),
    Image.asset('assets/images/doodle-1/wrong_3.png'),
    Image.asset('assets/images/doodle-1/wrong_4.png'),
    Image.asset('assets/images/doodle-1/wrong_5.png'),
    Image.asset('assets/images/doodle-1/wrong_6.png'),
  ];

  return Column(
    children: [
      Text('${translator.wonGames}: $wonGames'),
      Text('${translator.remainingGuesses}: ${maxMistakes - mistakeIndex}'),
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

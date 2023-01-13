import 'package:flutter/material.dart';

Widget keywordDisplay(
    {required BuildContext context,
    required String keyword,
    required List<String> usedLetters,
    required List<String> alphabet,
    required bool isGameLost}) {
  var keywordDisplay = keyword
      .split(' ')
      .map((word) => word
          .split('')
          .map((c) =>
              isGameLost || usedLetters.contains(c) || !alphabet.contains(c)
                  ? c
                  : '_')
          .join(''))
      .join(' ');

  var keywordDisplayFailedChars = keyword
      .split(' ')
      .map((word) => word
          .split('')
          .map((c) =>
              isGameLost && !usedLetters.contains(c) && alphabet.contains(c)
                  ? "1"
                  : "0")
          .join(''))
      .join(' ');

  return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(
          keywordDisplay.length,
          (index) => Text(keywordDisplay[index],
              textAlign: TextAlign.center,
              style: isGameLost && keywordDisplayFailedChars[index] == "1"
                ? const TextStyle(color: Colors.red)
              : Theme.of(context).textTheme.subtitle1)));
  return Text(keywordDisplay,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subtitle1);
}

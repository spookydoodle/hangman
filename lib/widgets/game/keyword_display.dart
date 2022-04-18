import 'package:flutter/material.dart';

Widget keywordDisplay(
    {required BuildContext context,
    required String keyword,
    required List<String> usedLetters}) {
  var keywordDisplay = keyword
      .split(' ')
      .map((word) =>
          word.split('').map((c) => usedLetters.contains(c) ? c : '_').join(''))
      .join(' ');

  return Text(keywordDisplay,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subtitle1);
}

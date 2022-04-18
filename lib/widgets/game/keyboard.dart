import 'package:flutter/material.dart';

Widget keyboard(
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

        return key(
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

Widget key(
        {required void Function() onPressed,
        required Widget child,
        required bool used}) =>
    used
        ? OutlinedButton(onPressed: onPressed, child: child)
        : ElevatedButton(onPressed: onPressed, child: child);

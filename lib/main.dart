import 'package:flutter/material.dart';
import 'package:hangman/theme/theme.dart';
import 'package:hangman/ui/game.dart';
import 'package:hangman/ui/home.dart';

void main() => runApp(new MaterialApp(
  theme: appTheme,
  home: Home(),
  // home: Game(),
));
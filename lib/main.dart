import 'package:flutter/material.dart';
import 'package:hangman/controller/file_controller.dart';
import 'package:hangman/pages/home.dart';
import 'package:hangman/theme/theme.dart';
import 'package:provider/provider.dart';


void main() => runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FileController())],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<FileController>().readText();
    // context.read<FileController>().readUser();
    // context.read<FileController>().readImage();
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Home(),
    );
  }
}

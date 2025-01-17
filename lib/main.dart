import 'package:flutter/material.dart';
import 'package:hangman/files/file_controller.dart';
import 'package:hangman/screens/home.dart';
import 'package:hangman/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
  providers: [ChangeNotifierProvider(create: (_) => FileController())],
  child: const App(),
));

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FileController>().readHeadlineIds();
    // context.read<FileController>().readUser();
    // context.read<FileController>().readImage();
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Home(),
    );
  }
}

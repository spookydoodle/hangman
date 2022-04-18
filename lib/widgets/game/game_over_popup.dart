import 'package:flutter/material.dart';
import 'package:hangman/settings/translator.dart';
import 'package:url_launcher/url_launcher.dart';

Widget gameOverPopup(
    {required Translator translator,
    required String message,
    required String buttonText,
    required String url,
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
                new InkWell(
                    child: new Text(translator.goToNews),
                    onTap: () => launch(url)),
                ElevatedButton(onPressed: onPressed, child: Text(buttonText))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          color: Colors.white70),
    ]),
  );
}

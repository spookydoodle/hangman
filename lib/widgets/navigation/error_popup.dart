import 'package:flutter/material.dart';

Widget errorPopup(String message, void Function() onContinue) {
  return Center(
    child: Column(children: [
      Spacer(),
      Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(message, style: TextStyle(color: Colors.white)),
                ElevatedButton(onPressed: onContinue, child: Text('Back'))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          color: Colors.amberAccent),
      Spacer(),
    ]),
  );
}

import 'package:flutter/material.dart';

class MenuButtonData {
  final String name;
  Function() onClick;

  MenuButtonData(this.name, this.onClick);
}

Widget menuButtons(BuildContext context, List<MenuButtonData> buttons) {
  return Padding(
    padding: const EdgeInsets.only(top: 40.0),
    child: Column(
      children: buttons.map((b) => menuButton(context, b.name, b.onClick)).toList(),
    ),
  );
}

Widget menuButton(BuildContext context, String name, onPressed) => SizedBox(
  width: 300.0,
  height: 60.0,
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        name,
        style: Theme.of(context).textTheme.button,
      ),
    ),
  ),
);

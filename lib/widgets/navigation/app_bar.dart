import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

PreferredSizeWidget appBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    actionsIconTheme: IconThemeData(
      color: Theme.of(context).primaryColor,
    ),
    actions: <Widget>[
      IconButton(icon: Icon(Icons.settings), onPressed: () {}),
      IconButton(icon: Icon(Icons.account_circle), onPressed: () {})
    ],
  );
}

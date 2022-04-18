import 'package:flutter/material.dart';

PreferredSizeWidget gameAppBar(BuildContext context, Function() onHome) => AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: onHome,
          color: Theme.of(context).accentColor,
          splashRadius: 20.0,
        ),
        Spacer(),
        Hero(
          tag: 'hero-avatar',
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset('assets/images/doodle-1/main.png'),
            ),
          ),
        ),
      ],
    );

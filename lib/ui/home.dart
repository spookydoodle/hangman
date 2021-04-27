import 'dart:ui';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var name = 'Hangman:\nGuess The News';
  var menuItems = <String>['Play', 'High Scores', 'Exit'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Main avatar / logo of the game
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 80,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('images/doodle-1/main.png'),
              ),
            ),
            //  Game Name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                name,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            //  Menu Item List
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: <Widget>[...menuItems.map((item) => Text(
                    item,
                  style: Theme.of(context).textTheme.headline6,
                ))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy code
// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: ListView(
//           children: <Widget>[
//             Text(
//               '1! ${Theme.of(context).textTheme.headline1.fontSize}',
//               style: Theme.of(context).textTheme.headline1,
//             ),
//             Text(
//               '2! ${Theme.of(context).textTheme.headline2.fontSize}',
//               style: Theme.of(context).textTheme.headline2,
//             ),
//             Text(
//               '3! ${Theme.of(context).textTheme.headline3.fontSize}',
//               style: Theme.of(context).textTheme.headline3,
//             ),
//             Text(
//               '4! ${Theme.of(context).textTheme.headline4.fontSize}',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//             Text(
//               '5! ${Theme.of(context).textTheme.headline5.fontSize}',
//               style: Theme.of(context).textTheme.headline5,
//             ),
//             Text(
//               '6! ${Theme.of(context).textTheme.headline6.fontSize}',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             Text(
//               'Subtitle1!  ${Theme.of(context).textTheme.subtitle1.fontSize}',
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//             Text(
//               'Subtitle2!  ${Theme.of(context).textTheme.subtitle2.fontSize}',
//               style: Theme.of(context).textTheme.subtitle2,
//             ),
//             Text(
//               'Body1! ${Theme.of(context).textTheme.bodyText1.fontSize}',
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//             Text(
//               'Body2!  ${Theme.of(context).textTheme.bodyText2.fontSize}',
//               style: Theme.of(context).textTheme.bodyText2,
//             ),
//             Text(
//               'Caption!  ${Theme.of(context).textTheme.caption.fontSize}',
//               style: Theme.of(context).textTheme.caption,
//             ),
//             Text(
//               'Overline!  ${Theme.of(context).textTheme.overline.fontSize}',
//               style: Theme.of(context).textTheme.overline,
//             ),
//             ElevatedButton(
//                 onPressed: () {},
//                 child: Text(
//                   'Button!  ${Theme.of(context).textTheme.button.fontSize}',
//                   style: Theme.of(context).textTheme.button,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
